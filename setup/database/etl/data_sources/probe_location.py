
from setup.database.etl.data_sources.data_source import DataSource


class ProbeLocationDataSource(DataSource):

    def __init__(self, probe_location_file='probe_locations.txt'):
        super(self.__class__, self).__init__(probe_location_file, read_options={
            'index_col': 'probe_id',
            'header': None,
            'names': ['probe_id', 'genome_locations']
        })
