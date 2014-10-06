
from setup.database.etl.data_sources.data_source import DataSource


class DrugInformationDataSource(DataSource):

    def __init__(self, drug_info_file='drug_info.csv'):
        super(self.__class__, self).__init__(drug_info_file)
