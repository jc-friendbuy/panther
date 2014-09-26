
from setup.database.etl.common.data_reader import CCLEDataReader
from setup.database.etl.common.processors import ETLProcessor


class LineInformationProcessor(ETLProcessor):

    def __init__(self, line_information_file='lines.csv'):
        super(self.__class__, self).__init__(line_information_file, {
            index_col: 0,
            quotechar: '"'
        })
