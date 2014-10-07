from sqlalchemy import select

from setup.database.etl.data_sources.line_information import LineInformationDataSource
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class CellLineETLProcessor(ETLProcessor):

    def __init__(self, dataset_id):
        super(self.__class__, self).__init__(dataset_id, [LineInformationDataSource], null_value='NULL')
        self.cancer_cell_lines = CCLEDatabase().cancer_cell_lines
        self.cell_line_sites = CCLEDatabase().cell_line_sites
        self.cell_line_sources = CCLEDatabase().cell_line_sources
        self.expression_arrays = CCLEDatabase().expression_arrays
        self.snp_arrays = CCLEDatabase().snp_arrays

    def load(self):
        for row_number, row in self.extract(LineInformationDataSource).iterrows():
            self._load_expression_array(row)
            self._load_snp_array(row)
            self._load_cell_line_site(row)
            self._load_cell_line_source(row)
            self._load_cancer_cell_line(row)

    def _load_expression_array(self, row):
        expression_array_name = self._get_value_or_none_if_equals_null(row['Expression arrays'])

        if expression_array_name is not None:
            table = self.expression_arrays
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                table,
                {table.c.name: expression_array_name},
                [table.c.name]
            )

    def _get_expression_array_id_from_name(self, name):
        table = self.expression_arrays
        return self._get_id_by_column_values(table, {table.c.name: name})

    def _load_snp_array(self, row):
        snp_array_name = self._get_value_or_none_if_equals_null(row['SNP arrays'])

        if snp_array_name is not None:
            table = self.snp_arrays
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                table,
                {table.c.name: snp_array_name},
                [table.c.name]
            )

    def _get_snp_array_id_from_name(self, name):
        table = self.snp_arrays
        return self._get_id_by_column_values(table, {table.c.name: name})

    def _load_cell_line_site(self, row):
        site_name = self._get_value_or_none_if_equals_null(row['Site Primary'])

        table = self.cell_line_sites
        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            table,
            {table.c.name: site_name},
            [table.c.name]
        )

    def _get_site_id_by_name(self, name):
        table = self.cell_line_sites
        return self._get_id_by_column_values(table, {table.c.name: name})

    def _load_cell_line_source(self, row):
        source_name = self._get_value_or_none_if_equals_null(row['Source'])

        if source_name is not None:
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                self.cell_line_sources,
                {self.cell_line_sources.c.name: source_name},
                [self.cell_line_sources.c.name]
            )

    def _get_source_id_by_name(self, name):
        table = self.cell_line_sources
        return self._get_id_by_column_values(table, {table.c.name: name})

    def _load_cancer_cell_line(self, row):
        ccle_name = self._get_value_or_none_if_equals_null(row['CCLE name'])
        primary_name = self._get_value_or_none_if_equals_null(row['Cell line primary name'])
        aliases = self._get_value_or_none_if_equals_null(row['Cell line aliases'])
        gender = self._get_value_or_none_if_equals_null(row['Gender'])
        site = self._get_value_or_none_if_equals_null(row['Site Primary'])
        histology = self._get_value_or_none_if_equals_null(row['Histology'])
        hist_subtype = self._get_value_or_none_if_equals_null(row['Hist Subtype1'])
        notes = self._get_value_or_none_if_equals_null(row['Notes'])
        source = self._get_value_or_none_if_equals_null(row['Source'])
        expression_arrays = self._get_value_or_none_if_equals_null(row['Expression arrays'])
        snp_arrays = self._get_value_or_none_if_equals_null(row['SNP arrays'])
        oncomap = self._get_value_or_none_if_equals_null(row['Oncomap'])
        hybrid_capture_sequencing = self._get_value_or_none_if_equals_null(row['Hybrid Capture Sequencing'])

        table = self.cancer_cell_lines

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.cancer_cell_lines, {
                table.c.ccleName: ccle_name,
                table.c.primaryName: primary_name,
                table.c.genderMale: gender == 'M' if gender is not None else gender,
                table.c.histology: histology,
                table.c.histologySubtype: hist_subtype,
                table.c.notes: notes,
                table.c.oncomap: oncomap == 'yes',
                table.c.hybridSequencing: hybrid_capture_sequencing == 'yes',
                table.c.aliases: aliases,
                table.c.CellLineSites_idCellLineSite: self._get_site_id_by_name(site),
                table.c.CellLineSources_idCellLineSource: self._get_source_id_by_name(source),
                table.c.ExpressionArrays_idExpressionArray: self._get_expression_array_id_from_name(expression_arrays),
                table.c.SNPArrays_idSNPArray: self._get_snp_array_id_from_name(snp_arrays),
            },
            [table.c.ccleName]
        )

    def get_cancer_cell_line_id_by_name(self, name):
        table = self.cancer_cell_lines
        return self._get_id_by_column_values(table, {table.c.ccleName: name})

    def add_cancer_cell_line_with_name(self, ccle_name):
        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.cancer_cell_lines, {
                self.cancer_cell_lines.c.ccleName: ccle_name
            },
            [self.cancer_cell_lines.c.ccleName]
        )

    def get_all_cancer_cell_line_names_for_site_name(self, site_name):
        cl = self.cancer_cell_lines
        s = self.cell_line_sites

        ccle_name_list = list()
        with CCLEDatabase().begin() as connection:
            query = select([cl.c.ccleName]).distinct() \
                .where(s.c.name == site_name) \
                .where(cl.c.CellLineSites_idCellLineSite == s.c.idCellLineSite)

            for table in [cl, s]:
                query = self._attach_where_clause_for_current_dataset_to_statement(table, query)

            for row in self._iterate_through_result_set(connection.execute(query)):
                ccle_name_list.append(row[cl.c.ccleName])

        for remove_line in ['MB157_BREAST']:
            try:
                ccle_name_list.remove(remove_line)
            except:
                pass

        return ccle_name_list
