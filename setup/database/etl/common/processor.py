
class ETLProcessor(object):

    def __init__(self, data_file, read_options):
        self._data_reader = CCLEDataReader()
        self._data_file = data_file
        self._read_options = read_options

    def _read(self):
        return self._data_reader.read(self._data_file, **self._read_options)

    def extract(self):
        return self._extract(self._read())

    def _extract(self, read_data):
        return read_data

    def _transform(self):
        raise NotImplementedError()

    def _load(self):
        raise NotImplementedError()
