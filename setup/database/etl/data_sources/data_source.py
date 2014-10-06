import os
import pandas


# TODO(jccotou): Improvement: extract rows from the datasource so that null values are properly handled.
# TODO(jccotou): Improvement: return rows line by line using pandas read_csv options.
class DataSource(object):

    def __init__(self, data_file, read_options=None, data_home_path='~/Projects/panther/data/'):
        self._data = None
        self._data_file = data_file
        self._data_home_dir = data_home_path
        self._read_options = read_options or dict()

    def _read(self):
        computed_file_path = self._get_file_path()
        self._data = pandas.read_csv(computed_file_path, **self._read_options)

    def _get_file_path(self):
        full_path = os.path.join(self._data_home_dir, self._data_file)
        expanded_path = os.path.expanduser(full_path)
        return os.path.normcase(expanded_path)

    @property
    def data(self):
        if self._data is None:
            self._read()
        return self._data
