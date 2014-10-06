from sqlalchemy import select

from setup.database.etl.processors.etl_processor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class DataSetETLProcessor(ETLProcessor):

    def __init__(self):
        super(self.__class__, self).__init__()
        self.data_sets = CCLEDatabase().data_sets

    def load(self, data_set_datetime, description):
        self._insert_dataset_if_not_present(
            data_set_datetime=data_set_datetime,
            description=description
        )

    def _insert_dataset_if_not_present(self, data_set_datetime, description):
        existing_data_set = self.get_dataset_id_for_date_and_description(data_set_datetime, description)
        if not existing_data_set:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    CCLEDatabase().data_sets.insert().values(
                        date=data_set_datetime,
                        description=description
                    )
                )

    def get_dataset_id_for_date_and_description(self, date, description):
        with CCLEDatabase().begin() as connection:
            existing_data_set = connection.execute(
                select([self.data_sets.c.idDataSet])
                .where(self.data_sets.c.date == date)
                .where(self.data_sets.c.description == description)
            ).scalar()
            return existing_data_set
