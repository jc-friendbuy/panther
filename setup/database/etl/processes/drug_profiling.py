from datetime import datetime
from setup.database.etl.data_sources import copy_number, drug_response,  drug_profile, \
    gene_expression, line_information


class CCLEETLProcess(object):

    def __init__(self):
        self._copy_number = None
        self._drug_response = None
        self._gene_expression = None
        self._line_information = None

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

    def _set_data_set(self, data_set_datetime=None):

        if not data_set_datetime:
            data_set_datetime = datetime(2014, 9, 30)





def run():
    process = CCLEETLProcess()
    process.extract()
    print "Done."

