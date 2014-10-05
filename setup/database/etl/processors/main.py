from datetime import datetime
from setup.database.etl.processors.data_set import DataSetProcessor
from setup.database.etl.processors.processor import Processor


class CCLEETLProcessor(Processor):

    def load(self):
        dataset_date = datetime(2014, 9, 30)
        dataset_description = 'This is the default dataset created for this version of the data.'
        dataset_processor = DataSetProcessor()
        dataset_processor.load(dataset_date, dataset_description)
        current_data_set = dataset_processor.get_dataset_for_date(dataset_date)
        # GeneAndChromosomeProcess().run()
