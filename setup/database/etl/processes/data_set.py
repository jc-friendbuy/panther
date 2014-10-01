from datetime import datetime

class DataSetProcess(object):

    def run(self):
        self._set_data_set()

    def _set_data_set(self, data_set_datetime=None):

            if not data_set_datetime:
                data_set_datetime = datetime(2014, 9, 30)