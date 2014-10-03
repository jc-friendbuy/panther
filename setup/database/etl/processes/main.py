from setup.database.etl.data_sources import copy_number, drug_response,  drug_profile, \
    gene_expression, line_information
from setup.database.etl.processes.data_set import DataSetProcessor
from setup.database.etl.processes.drug_profiling import DrugProfilingProcessor
from setup.database.etl.processes.genes_and_chromosomes import GeneAndChromosomeProcessor
from setup.database.etl.processes.processor import Processor


class CCLEETLProcessor(Processor):

    def run(self):
        current_data_set_id = DataSetProcessor().run()
        # GeneAndChromosomeProcess().run()
