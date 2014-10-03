from sqlalchemy import select
from setup.database.etl.data_sources.line_information import LineInformationDataSource
from setup.database.etl.processes.processor import Processor
from setup.database.metadata.database import CCLEDatabase


class CellLineProcessor(Processor):
    def __init__(self):
        self.cancer_cell_lines = CCLEDatabase().cancer_cell_lines
        self.cell_line_sites = CCLEDatabase().cell_line_sites
        self.cell_line_sources = CCLEDatabase().cell_line_sources
        self.expression_arrays = CCLEDatabase().expression_arrays
        self.snp_arrays = CCLEDatabase().snp_arrays

        self._cell_line_data = None

    def run(self, dataset_id):

        do_expression_arrays = self._data_exists_in_table_for_dataset(self.expression_arrays, dataset_id)
        do_snp_arrays = self._data_exists_in_table_for_dataset(self.snp_arrays, dataset_id)
        do_cell_line_sites = self._data_exists_in_table_for_dataset(self.cell_line_sites, dataset_id)
        do_cell_line_sources = self._data_exists_in_table_for_dataset(self.cell_line_sources, dataset_id)
        do_cancer_cell_lines = self._data_exists_in_table_for_dataset(self.cancer_cell_lines, dataset_id)

        if any([do_expression_arrays, do_snp_arrays, do_cell_line_sites, do_cell_line_sources, do_cancer_cell_lines]):
            self._load_cell_line_data_if_not_loaded()
            for row_number, row in self._cell_line_data.iterrows():
                if do_expression_arrays:
                    self._process_expression_array(row, dataset_id)

                if do_snp_arrays:
                    self._process_snp_array(row, dataset_id)

                if do_cell_line_sites:
                    self._process_cell_line_site(row, dataset_id)

                if do_cell_line_sources:
                    self._process_cell_line_source(row, dataset_id)

                if do_cancer_cell_lines:
                    self._process_cancer_cell_line(row, dataset_id)

    def _load_cell_line_data_if_not_loaded(self):
        if not self._cell_line_data:
            self._cell_line_data = LineInformationDataSource().data

    def _process_expression_array(self, row, dataset_id):
        expression_array_name = row['Expression arrays']

        existing_expression_array = self._get_expression_array_id_from_name(expression_array_name, dataset_id)
        if not existing_expression_array:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    self.expression_arrays.insert().values(
                        name=expression_array_name,
                        DataSet_idDataSet=dataset_id
                    )
                )

    def _get_expression_array_id_from_name(self, name, dataset_id):
        with CCLEDatabase().begin() as connection:
            return connection.execute(
                select([self.expression_arrays.c.idExpressionArray])
                .where(self.expression_arrays.c.name == name)
                .where(self.expression_arrays.c.DataSet_idDataSet == dataset_id)
            ).scalar()

    def _process_snp_array(self, row, dataset_id):
        snp_array_name = row['SNP arrays']

        existing_snp_array = self._get_snp_array_id_from_name(snp_array_name, dataset_id)
        if not existing_snp_array:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    self.snp_arrays.insert().values(
                        name=snp_array_name,
                        DataSet_idDataSet=dataset_id
                    )
                )

    def _get_snp_array_id_from_name(self, name, dataset_id):
        with CCLEDatabase().begin() as connection:
            return connection.execute(
                select([self.snp_arrays.c.idSNPArray])
                .where(self.snp_arrays.c.name == name)
                .where(self.snp_arrays.c.DataSet_idDataSet == dataset_id)
            ).scalar()

    def _process_cell_line_site(self, row, dataset_id):
        site_name = row['Site Primary']

        existing_site = self._get_site_id_by_name(site_name, dataset_id)
        if not existing_site:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    self.cell_line_sites.insert().values(
                        name=site_name,
                        DataSet_idDataSet=dataset_id
                    )
                )

    def _get_site_id_by_name(self, name, dataset_id):
        with CCLEDatabase().begin() as connection:
            return connection.execute(
                select([self.cell_line_sites.c.idCellLineSite])
                .where(self.cell_line_sites.c.name == name)
                .where(self.cell_line_sites.c.DataSet_idDataSet == dataset_id)
            ).scalar()

    def _process_cell_line_source(self, row, dataset_id):
        source_name = row['Source']

        existing_source = self._get_source_id_by_name(source_name, dataset_id)
        if not existing_source:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    self.cell_line_sources.insert().values(
                        name=source_name,
                        DataSet_idDataSet=dataset_id
                    )
                )

    def _get_source_id_by_name(self, name, dataset_id):
        with CCLEDatabase().begin() as connection:
            return connection.execute(
                select([self.cell_line_sources.c.idCellLineSource])
                .where(self.cell_line_sources.c.name == name)
                .where(self.cell_line_sources.c.DataSet_idDataSet == dataset_id)
            ).scalar()

    def _process_cancer_cell_line(self, row, dataset_id):
            chromosome = row[2]
            chromosome_id = self._insert_chromosome_from_name_if_not_present_and_get_id(chromosome)

            egid = row[0]
            symbol = row[1]
            loc_start = row[3]
            loc_end = row[4]

            self._insert_gene_if_not_present(egid, symbol, loc_start, loc_end, chromosome_id)

    def _insert_chromosome_from_name_if_not_present_and_get_id(self, chromosome_name):
        stored_chromosome = self._get_chromosome_from_name(chromosome_name)

        if not stored_chromosome:
            with CCLEDatabase().begin() as connection:
                chromosome_id = connection.execute(
                    self.chromosomes.insert().values(
                        name=chromosome_name,
                    ).returning(self.chromosomes.idChromosome)
                )
        else:
            chromosome_id = stored_chromosome[self.chromosomes.c.idChromosome]

        return chromosome_id

    def _get_chromosome_from_name(self, chromosome_name):
        with CCLEDatabase().begin() as connection:
            existing_chromosome = connection.execute(
                select([self.chromosomes])
                .where(self.chromosomes.c.name == chromosome_name)
            ).first()
        return existing_chromosome

    def _insert_gene_if_not_present(self, egid, symbol, loc_start, loc_end, chromosome_id):
        with CCLEDatabase().begin() as connection:
            existing_gene = connection.execute(
                select([self.genes])
                .where(self.genes.c.egid == egid)
            ).first()

            if not existing_gene:
                connection.execute(
                    self.genes.insert().values(
                        egid=egid,
                        symbol=symbol,
                        chromosomeLocStart=loc_start,
                        chromosomeLocEnd=loc_end,
                        Chromosomes_idChromosome=chromosome_id
                    )
                )


