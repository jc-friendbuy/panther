from datetime import datetime

from setup.database.etl.processors.cell_lines import CellLineETLProcessor
from setup.database.etl.processors.data_set import DataSetETLProcessor
from setup.database.etl.processors.drug_response import DrugResponseETLProcessor
from setup.database.etl.processors.gene_copy_number import BreastSpecificGeneCopyNumberETLProcessor
from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.etl.processors.gene_expression import BreastSpecificGeneExpressionETLProcessor


class CancerCellLineEncyclopediaETLETLProcessor(ETLProcessor):

    def load(self):
        dataset_date = datetime(2014, 9, 30)
        dataset_description = 'This is the default dataset created for this version of the data.'
        dataset_processor = DataSetETLProcessor()
        print('Loading DataSet....')
        dataset_processor.load(dataset_date, dataset_description)
        current_dataset_id = dataset_processor.get_dataset_id_for_date_and_description(
            dataset_date, dataset_description
        )

        cell_line_processor = CellLineETLProcessor(current_dataset_id)
        print('Loading Cell Lines....')
        cell_line_processor.load()
        copy_number_processor = BreastSpecificGeneCopyNumberETLProcessor(current_dataset_id, cell_line_processor)
        print('Loading Copy Number....')
        copy_number_processor.load()

        gene_expression_processor = BreastSpecificGeneExpressionETLProcessor(
            current_dataset_id, cell_line_processor, copy_number_processor
        )
        print('Loading Gene Expression....')
        gene_expression_processor.load()

        drug_response_processor = DrugResponseETLProcessor(current_dataset_id, cell_line_processor)
        print('Loading Drug Response....')
        drug_response_processor.load()
        print('Done')
