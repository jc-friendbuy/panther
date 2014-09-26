
from setup.database.etl.common.data_reader import CCLEDataReader
from setup.database.etl.common.processors import ETLProcessor


class DrugResponseProcessor(ETLProcessor):

    def __init__(self, drug_response_file='drug.csv'):
        super(self.__class__, self).__init__(drug_response_file, {
            index_col: 0
        })
