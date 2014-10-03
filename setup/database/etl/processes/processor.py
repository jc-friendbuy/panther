from sqlalchemy import select
from setup.database.metadata.database import CCLEDatabase


class Processor(object):

    @staticmethod
    def _data_exists_in_table_for_dataset(table, dataset_id):
        with CCLEDatabase().begin() as connection:
            existing_dataset_row = connection.execute(
                select([table])
                .where(table.c.DataSets_idDataSet == dataset_id)
            ).first()
        return existing_dataset_row is not None
