
from setup.database.etl.data_sources.data_source import DataSource


class CopyNumberDataSource(DataSource):

    def __init__(self, copy_number_file='copynumber.txt'):
        super(self.__class__, self).__init__(copy_number_file,
                                             read_options={
                                                 'index_col': 0,
                                                 'delim_whitespace': True
                                             })