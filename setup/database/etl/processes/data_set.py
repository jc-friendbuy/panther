from datetime import datetime
from sqlalchemy import select
from setup.database.metadata.database import CCLEDatabase


class DataSetProcess(object):

    def __init__(self):
        self.data_sets = CCLEDatabase().data_sets

    def run(self, data_set_datetime=None, description=None):
        return self.get_dataset_id(
            self._insert_dataset_if_not_present_and_return_current_dataset(
                data_set_datetime=data_set_datetime,
                description=description
            )
        )

    def _insert_dataset_if_not_present_and_return_current_dataset(self, data_set_datetime=None, description=None):
            if not data_set_datetime:
                data_set_datetime = datetime(2014, 9, 30)

            if not description:
                description = 'This is the default dataset created for this version of the data.'

            existing_data_set = self._get_dataset_for_date(data_set_datetime)

            if existing_data_set:
                return existing_data_set
            else:
                with CCLEDatabase().begin() as connection:

                    connection.execute(
                        CCLEDatabase().data_sets.insert().values(
                            Date=data_set_datetime,
                            Description=description
                        )
                    )

                return self._get_dataset_for_date(data_set_datetime)

    def _get_dataset_for_date(self, date):
        with CCLEDatabase().begin() as connection:

            existing_data_set = connection.execute(
                select([self.data_sets]).where(self.data_sets.c.Date == date)
            ).first()

            return existing_data_set

    def get_dataset_id(self, dataset):
        return dataset[self.data_sets.c.idDataSet]
