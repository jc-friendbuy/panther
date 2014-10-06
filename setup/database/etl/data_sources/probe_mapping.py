
from setup.database.etl.data_sources.data_source import DataSource


class ProbeMappingDataSource(DataSource):

    def __init__(self, probe_gene_mapping_file='probe_gene_mapping.txt'):
        super(self.__class__, self).__init__(probe_gene_mapping_file, read_options={
            'index_col': 'probe_id',
            'header': None,
            'names': ['probe_id', 'symbols']
        })
