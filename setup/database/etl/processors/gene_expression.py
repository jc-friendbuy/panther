from setup.database.etl.data_sources.gene_expression import GeneExpressionDataSource, LineSubsetGeneExpressionDataSource
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class GeneExpressionETLProcessor(ETLProcessor):

    def __init__(self, dataset_id, cancer_cell_line_etl_processor, gene_copy_number_etl_processor, data_sources=None):
        if not data_sources:
            data_sources = [GeneExpressionDataSource]
        super(GeneExpressionETLProcessor, self).__init__(dataset_id, data_sources)
        self.gene_expression = CCLEDatabase().gene_expressions
        self.gene_transcripts = CCLEDatabase().gene_transcripts

        self._cancer_cell_line_etl_processor = cancer_cell_line_etl_processor
        self._gene_copy_number_etl_processor = gene_copy_number_etl_processor

    def load(self):
        for row_number, row in self.extract(GeneExpressionDataSource).iterrows():
            self._load_gene_transcript(row)
            self._load_gene_expression(row)

    def _load_gene_transcript(self, row):
        t = self.gene_transcripts

        probe_id = self._get_value_or_none_if_equals_null(row['Name'])
        symbol = self._get_value_or_none_if_equals_null(row['Description'])
        matching_gene_id = self._gene_copy_number_etl_processor.get_gene_id_from_symbol(symbol)

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            t, {
                t.c.probeId: probe_id,
                t.c.Genes_idGene: matching_gene_id,
            },
            [t.c.probeId]
        )

    def _load_gene_expression(self, row):
        ex = self.gene_expression

        probe_id = self._get_value_or_none_if_equals_null(row['Name'])
        gene_transcript_id = self._get_transcript_id_from_probe_id(probe_id)

        for cell_line_name in self._get_cell_line_column_values():
            ccle_line_id = self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(cell_line_name)

            if ccle_line_id is None:
                self._cancer_cell_line_etl_processor.add_cancer_cell_line_with_name(cell_line_name)
                ccle_line_id = self._cancer_cell_line_etl_processor.get_cancer_cell_line_id_by_name(cell_line_name)

            rma_normalized_expression = self._get_value_or_none_if_equals_null(row[cell_line_name])
            self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
                ex, {
                    ex.c.quantileNormalizedRMAExpression: rma_normalized_expression,
                    ex.c.CancerCellLines_idCancerCellLine: ccle_line_id,
                    ex.c.GeneTranscripts_idGeneTranscript: gene_transcript_id
                },
                [ex.c.CancerCellLines_idCancerCellLine, ex.c.GeneTranscripts_idGeneTranscript]
            )

    def _get_cell_line_column_values(self):
        # TODO: THis should be done in the Data Source
        return list(self._data[GeneExpressionDataSource].columns.values)[2:]

    def _get_transcript_id_from_probe_id(self, probe_id):
        return self._get_id_by_column_values(self.gene_transcripts, {
            self.gene_transcripts.c.probeId: probe_id}
        )


class BreastSpecificGeneExpressionETLProcessor(GeneExpressionETLProcessor):

    def __init__(self, dataset_id, cancer_cell_line_etl_processor, gene_copy_number_etl_processor):
        breast_cell_lines = cancer_cell_line_etl_processor.get_all_cancer_cell_line_names_for_site_name('breast')
        all_cols_to_use = list(xrange(6)) + breast_cell_lines
        breast_specific_data_source = LineSubsetGeneExpressionDataSource(cell_line_column_names=all_cols_to_use)
        super(BreastSpecificGeneExpressionETLProcessor, self).__init__(
            dataset_id,
            cancer_cell_line_etl_processor,
            gene_copy_number_etl_processor,
            data_sources=[breast_specific_data_source]
        )

    def load(self):
        for row_number, row in self.extract(LineSubsetGeneExpressionDataSource).iterrows():
            self._load_gene_transcript(row)
            self._load_gene_expression(row)

    def _get_cell_line_column_values(self):
        return list(self._data[LineSubsetGeneExpressionDataSource].columns.values)[2:]