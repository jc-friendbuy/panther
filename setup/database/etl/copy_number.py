
from setup.database.etl.common.data_reader import CCLEDataReader
from setup.database.etl.common.processors import ETLProcessor


class GeneCopyNumberProcessor(ETLProcessor):

    def __init__(self, copy_number_file='copynumber.txt'):
        super(self.__class__, self).__init__(copy_number_file, {
            index_col: 0,
            delim_whitespace: True
        })
