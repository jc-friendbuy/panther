from setup.database.etl.data_sources import copy_number, drug_response,  drug_profile, \
    gene_expression, line_information
from setup.database.etl.processes.data_set import DataSetProcess
from setup.database.etl.processes.drug_profiling import DrugProfilingProcess


class CCLEETLProcess(object):

    def __init__(self):
        self._copy_number = None
        self._drug_response = None
        self._gene_expression = None
        self._line_information = None

    def run(self):
        data_set_process = DataSetProcess()
        current_data_set_id = data_set_process.run()
        DrugProfilingProcess.run(current_data_set_id)

    def extract(self):
        self._copy_number = copy_number.CopyNumberDataSource()
        self._copy_number.data
        self._drug_response = drug_response.DrugResponseDataSource()
        self._drug_response.data
        self._drug_profile = drug_profile.DrugProfileDataSource()
        self._drug_profile.data
        self._gene_expression = gene_expression.GeneExpressionDataSource()
        self._gene_expression.data
        self._line_information = line_information.LineInformationDataSource()
        self._line_information.data
        pass

    def transform(self):
        pass

    def load(self):
        pass


