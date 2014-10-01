
from setup.database.etl.data_sources.data_source import DataSource


class GeneExpressionDataSource(DataSource):

    def __init__(self, gene_expression_file='expression.gct'):
        super(self.__class__, self).__init__(gene_expression_file,
                                                read_options={
                                                    'skiprows': 2,
                                                    'index_col': 0,
                                                    'delim_whitespace': True
                                                })
