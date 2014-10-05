from sqlalchemy import select

from setup.database.etl.processors.processor import Processor
from setup.database.metadata.database import CCLEDatabase


class DataSetProcessor(Processor):

    def __init__(self):
        super(self.__class__, self).__init__()
        self.data_sets = CCLEDatabase().data_sets

    def load(self, data_set_datetime, description):
        return self._get_dataset_id(
            self._insert_dataset_if_not_present_and_return_current_dataset(
                data_set_datetime=data_set_datetime,
                description=description
            )
        )

    def _insert_dataset_if_not_present_and_return_current_dataset(self, data_set_datetime, description):
        existing_data_set = self.get_dataset_for_date(data_set_datetime)

        if existing_data_set:
            return existing_data_set
        else:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    CCLEDatabase().data_sets.insert().values(
                        date=data_set_datetime,
                        description=description
                    )
                )

            return self.get_dataset_for_date(data_set_datetime)

    def get_dataset_for_date(self, date):
        with CCLEDatabase().begin() as connection:
            existing_data_set = connection.execute(
                select([self.data_sets]).where(self.data_sets.c.date == date)
            ).first()
            return existing_data_set

    def _get_dataset_id(self, dataset):
        return dataset[self.data_sets.c.idDataSet]
