import traceback

from setup.database.etl.data_sources.gene_expression import GeneExpressionDataSource
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class GeneExpressionETLProcessor(ETLProcessor):

    def __init__(self, dataset_id, cancer_cell_line_etl_processor, gene_copy_number_etl_processor):
        super(self.__class__, self).__init__(
            dataset_id, [GeneExpressionDataSource])
        self.gene_expression = CCLEDatabase().gene_expressions
        self.gene_transcripts = CCLEDatabase().gene_transcripts
        self.genes = CCLEDatabase().genes

        self._cancer_cell_line_etl_processor = cancer_cell_line_etl_processor
        self._gene_copy_number_etl_processor = gene_copy_number_etl_processor

    def load(self):
        self._load_gene_expressions()

    def _load_gene_expressions(self):
        for row_number, row in self.extract(GeneExpressionDataSource).iterrows():
            self._load_gene_transcript(row)
            self._load_gene_expression(row)

    def _load_gene_transcript(self, row):
        t = self.gene_transcripts

        probe_id = self._get_value_or_none_if_equals_null(row['Name'])
        symbol = self._get_value_or_none_if_equals_null(row['Description'])
        matching_gene_id = self._get_gene_id_by_symbol(symbol)

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            t, {
                t.c.probeId: probe_id,
                t.c.Genes_idGene: matching_gene_id,
            },
            [t.c.name]
        )

    #TODO
    def _get_gene_id_by_symbol(self, symbol):
        return self._gene_copy_number_etl_processor.get_gene_id_from_symbol(symbol)

    def _load_gene_expression(self, row):
        ex = self.gene_expression

        probe_id = self._get_value_or_none_if_equals_null(row['Name'])
        gene_transcript_id = self._get_transcript_id_from_probe_id(probe_id)

        # TODO: This should be done in the data source
        cell_line_column_values = list(self._data[GeneExpressionDataSource].columns.values)[2:]

        for cell_line_name in cell_line_column_values:
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

    def _get_transcript_id_from_probe_id(self, probe_id):
        return self._get_id_by_column_values(self.gene_transcripts, {
            self.genes.c.probeId: probe_id}
        )