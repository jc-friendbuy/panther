import os
import pandas

class CCLEDataReader(object):

    def __init__(self, data_home_path='~/Projects/panther/data/'):
        self._data_home_dir = data_home_path

    def read(self, file_name):
        computed_file_path = self._get_file_path(file_name)
        return self._read(computed_file_path)

    def _get_file_path(self, file_name):
        full_path = os.path.join(self._data_home_dir, file_name)
        expanded_path = os.path.expanduser(full_path)
        return os.path.normcase(expanded_path)



class CopyNumberReader(CCLEDataReader):

    def _read(self, computed_file_path):
        return pandas.read_csv(computed_file_path,
                               index_col=0,
                               delim_whitespace=True)

class DrugResponseReader(CCLEDataReader):

    def _read(self, computed_file_path):
        return pandas.read_csv(computed_file_path, index_col=0)

class GeneExpressionReader(CCLEDataReader):

    def _read(self, computed_file_path):
        return pandas.read_csv(computed_file_path,
                               skiprows=2,
                               index_col=0,
                               delim_whitespace=True)

class CellLineInformationReader(CCLEDataReader):

    def _read(self, computed_file_path):
        return pandas.read_csv(computed_file_path,
                               index_col=0,
                               quotechar='"')
