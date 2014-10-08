from setup.database.etl.data_sources.copy_number import GeneCopyNumberDataSource, LineSubsetGeneCopyNumberDataSource
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class GeneCopyNumberETLProcessor(ETLProcessor):

        def __init__(self, dataset_id, cell_line_processor, data_sources=None):
            if not data_sources:
                data_sources = [GeneCopyNumberDataSource]
            super(GeneCopyNumberETLProcessor, self).__init__(dataset_id, data_sources)
            self.chromosomes = CCLEDatabase().chromosomes
            self.gene_copy_numbers = CCLEDatabase().gene_copy_numbers
            self.genes = CCLEDatabase().genes

            self._cancer_cell_line_etl_processor = cell_line_processor

        def load(self):
            for row_number, row in self.extract(GeneCopyNumberDataSource).iterrows():
                self._load_chromosome(row)
                self._load_gene(row)
                self._load_gene_copy_number(row)

        def _load_chromosome(self, row):
            chromosomes = self.chromosomes

            chromosome = self._get_value_or_none_if_equals_null(row['CHR'])
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                chromosomes, {
                    chromosomes.c.name: chromosome,
                },
                [chromosomes.c.name]
            )

        def _load_gene(self, row):
            genes = self.genes

            chromosome = self._get_value_or_none_if_equals_null(row['CHR'])
            chromosome_id = self._get_chromosome_id_from_name(chromosome)

            egid = self._get_value_or_none_if_equals_null(row['EGID'])
            symbol = self._get_value_or_none_if_equals_null(row['SYMBOL'])
            loc_start = self._get_value_or_none_if_equals_null(row['CHRLOC'])
            loc_end = self._get_value_or_none_if_equals_null(row['CHRLOCEND'])
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                genes, {
                    genes.c.egid: egid,
                    genes.c.symbol: symbol,
                    genes.c.chromosomeLocStart: loc_start,
                    genes.c.chromosomeLocEnd: loc_end,
                    genes.c.Chromosomes_idChromosome: chromosome_id
                },
                [genes.c.egid]
            )

        def _get_chromosome_id_from_name(self, chromosome_name):
            return self._get_id_by_column_values(self.chromosomes, {
                self.chromosomes.c.name: chromosome_name}
            )

        def _load_gene_copy_number(self, row):
            gene_cn = self.gene_copy_numbers

            gene_id = self._get_gene_id_from_egid(self._get_value_or_none_if_equals_null(row['EGID']))

            # TODO: This should be done in the data source
            for cell_line_name in self._get_cell_line_column_values():
                cancer_cell_line_id = \
                    self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(cell_line_name)

                if cancer_cell_line_id is None:
                    self._cancer_cell_line_etl_processor.add_cancer_cell_line_with_name(cell_line_name)
                    cancer_cell_line_id = \
                        self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(cell_line_name)

                snp_copy_number_value = row[cell_line_name]

                self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                    gene_cn, {
                        gene_cn.c.snpCopyNumber2Log2: snp_copy_number_value,
                        gene_cn.c.CancerCellLines_idCancerCellLine: cancer_cell_line_id,
                        gene_cn.c.Genes_idGene: gene_id,
                    },
                    [gene_cn.c.CancerCellLines_idCancerCellLine, gene_cn.c.Genes_idGene]
                )

        def _get_cell_line_column_values(self):
            return list(self._data[GeneCopyNumberDataSource].columns.values)[5:]

        def _get_gene_id_from_egid(self, egid):
            return self._get_id_by_column_values(self.genes, {
                self.genes.c.egid: egid}
            )

        def get_gene_id_from_symbol(self, symbol):
            return self._get_id_by_column_values(self.genes, {
                self.genes.c.symbol: symbol}
            )


class BreastSpecificGeneCopyNumberETLProcessor(GeneCopyNumberETLProcessor):

    def __init__(self, dataset_id, cell_line_processor):
        breast_cell_lines = cell_line_processor.get_all_cancer_cell_line_names_for_site_name('breast')
        all_cols_to_use = list(xrange(6)) + breast_cell_lines
        breast_specific_data_source = LineSubsetGeneCopyNumberDataSource(cell_line_column_names=all_cols_to_use)
        super(BreastSpecificGeneCopyNumberETLProcessor, self).__init__(
            dataset_id,
            cell_line_processor,
            data_sources=[breast_specific_data_source]
        )

    def load(self):
        for row_number, row in self.extract(LineSubsetGeneCopyNumberDataSource).iterrows():
            self._load_chromosome(row)
            self._load_gene(row)
            self._load_gene_copy_number(row)

    def _get_cell_line_column_values(self):
            return list(self._data[LineSubsetGeneCopyNumberDataSource].columns.values)[5:]