
from setup.database.etl.data_sources.data_source import DataSource


class GeneExpressionDataSource(DataSource):

    def __init__(self, gene_expression_file='expression.gct', additional_options=None):
        read_options = {
            'skiprows': 2,
            'delim_whitespace': True
        }
        if additional_options:
            read_options.update(additional_options)
        super(GeneExpressionDataSource, self).__init__(gene_expression_file, read_options=read_options)


class LineSubsetGeneExpressionDataSource(GeneExpressionDataSource):

    def __init__(self, gene_expression_file='expression.gct', cell_line_column_names=None):
        if not cell_line_column_names:
            additional_options = None
        else:
            additional_options = {
                'usecols': cell_line_column_names
            }
        super(LineSubsetGeneExpressionDataSource, self).__init__(gene_expression_file, additional_options=additional_options)
