
from setup.database.etl.data_sources.data_source import DataSource


class GeneCopyNumberDataSource(DataSource):

    def __init__(self, copy_number_file='copynumber.txt', additional_options=None):
        read_options = {
            'delim_whitespace': True,
            'dtype': {
                'EGID': object
            }
        }
        if additional_options:
            read_options.update(additional_options)

        super(GeneCopyNumberDataSource, self).__init__(copy_number_file, read_options)


class LineSubsetGeneCopyNumberDataSource(GeneCopyNumberDataSource):

    def __init__(self, copy_number_file='copynumber.txt', cell_line_column_names=None):
        if not cell_line_column_names:
            additional_options = None
        else:
            additional_options = {
                'usecols': cell_line_column_names
            }

        super(LineSubsetGeneCopyNumberDataSource, self).\
            __init__(copy_number_file, additional_options=additional_options)
