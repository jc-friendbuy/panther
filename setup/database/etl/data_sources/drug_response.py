
from setup.database.etl.data_sources.data_source import DataSource


class DrugResponseDataSource(DataSource):

    def __init__(self, drug_response_file='drug.txt'):
        super(self.__class__, self).__init__(drug_response_file, read_options={
            'sep': '\t'
        })
