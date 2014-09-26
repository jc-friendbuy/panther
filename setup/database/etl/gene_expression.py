
from setup.database.etl.common.data_reader import CCLEDataReader
from setup.database.etl.common.processors import ETLProcessor


class GeneExpressionProcessor(ETLProcessor):

    def __init__(self, gene_expression_file='expression.gct'):
        super(self.__class__, self).__init__(gene_expression_file, {
            skiprows: 2,
            index_col: 0,
            delim_whitespace: True
        })
