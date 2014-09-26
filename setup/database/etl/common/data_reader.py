import os
import pandas

class CCLEDataReader(object):

    def __init__(self, data_home_path='~/Projects/panther/data/'):
        self._data_home_dir = data_home_path

    def read(self, file_name, read_options):
        computed_file_path = self._get_file_path(file_name)
        return pandas.read_csv(computed_file_path, **read_options)

    def _get_file_path(self, file_name):
        full_path = os.path.join(self._data_home_dir, file_name)
        expanded_path = os.path.expanduser(full_path)
        return os.path.normcase(expanded_path)
