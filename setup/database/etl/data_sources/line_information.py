
from setup.database.etl.data_sources.data_source import DataSource


class LineInformationDataSource(DataSource):

    def __init__(self, line_information_file='lines.csv'):
        super(self.__class__, self).__init__(line_information_file,
                                             read_options={
                                                 'quotechar': '"',
                                                 'dtype': {
                                                     'Hybrid Capture Sequencing': str
                                                 }
                                             })
