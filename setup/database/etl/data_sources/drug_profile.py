
from setup.database.etl.data_sources.data_source import DataSource


class DrugProfileDataSource(DataSource):

    def __init__(self, drug_response_file='drug_profile.csv'):
        super(self.__class__, self).__init__(drug_response_file)
