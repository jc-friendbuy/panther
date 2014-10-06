from datetime import datetime

from setup.database.etl.processors.cell_lines import CellLineETLProcessor
from setup.database.etl.processors.data_set import DataSetETLProcessor
from setup.database.etl.processors.gene_copy_number import GeneCopyNumberETLProcessor
from setup.database.etl.processors.etl_processor import ETLProcessor


class CancerCellLineEncyclopediaETLETLProcessor(ETLProcessor):

    def load(self):
        dataset_date = datetime(2014, 9, 30)
        dataset_description = 'This is the default dataset created for this version of the data.'
        dataset_processor = DataSetETLProcessor()
        dataset_processor.load(dataset_date, dataset_description)
        current_data_set = dataset_processor.get_dataset_id_for_date_and_description(dataset_date, dataset_description)
        cell_line_processor = CellLineETLProcessor(current_data_set)
        cell_line_processor.load()
        copy_number_processor = GeneCopyNumberETLProcessor(current_data_set, cell_line_processor)
        copy_number_processor.load()
