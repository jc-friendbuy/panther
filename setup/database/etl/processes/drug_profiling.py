from datetime import datetime
from sqlalchemy import select
from setup.database.metadata.database import CCLEDatabase


class DrugProfilingProcess(object):

    def __init__(self):
        self.drug_responses = CCLEDatabase().drug_responses
        self.drug_response_doses = CCLEDatabase().drug_response_doses
        self.therapy_compounds = CCLEDatabase().therapy_compounds

    def run(self, data_set_id):
        # self._copy_number = copy_number.CopyNumberDataSource()
        # self._copy_number.data
        # self._drug_response = drug_response.DrugResponseDataSource()
        # self._drug_response.data
        # self._drug_profile = drug_profile.DrugProfileDataSource()
        # self._drug_profile.data
        # self._gene_expression = gene_expression.GeneExpressionDataSource()
        # self._gene_expression.data
        # self._line_information = line_information.LineInformationDataSource()
        # self._line_information.data

        self._set_data_set(data_set_datetime=data_set_datetime, description=description)

    def _set_data_set(self, data_set_datetime=None, description=None):

            if not data_set_datetime:
                data_set_datetime = datetime(2014, 9, 30)

            if not description:
                description = 'This is the default dataset created for this version of the data.'

            with CCLEDatabase().begin() as connection:

                existing_data_set = connection.execute(
                    select([self.table]).where(self.table.c.Date == data_set_datetime)
                ).first()

                if not existing_data_set:
                    connection.execute(
                        CCLEDatabase().data_sets.insert().values(
                            Date=data_set_datetime,
                            Description=description
                        )
                    )


