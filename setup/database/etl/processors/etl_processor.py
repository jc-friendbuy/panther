import inspect
import math

from sqlalchemy import select

from setup.database.metadata.database import CCLEDatabase


class ETLProcessor(object):

    # NOTE: null_value is hackish.  This should be done through the data source, which should return a row object and
    #  automatically determine which values are None based on knowledge of the data.
    def __init__(self, dataset_id=None, data_source_classes=None, null_value=None):
        self._data_sources = dict()
        self._data = dict()
        self._dataset_id = dataset_id
        self._tables = list()
        self._null_value = null_value
        data_source_classes = list() if data_source_classes is None else data_source_classes

        for data_source_description in data_source_classes:
            if inspect.isclass(data_source_description):
                data_source = data_source_description()
                self._data_sources[data_source_description] = data_source
            else:
                data_source = data_source_description
                self._data_sources[data_source_description.__class__] = data_source

    def extract(self, data_source_class):
        self._extract_data_from_source_if_not_already_loaded(data_source_class)
        return self._data[data_source_class]

    def _extract_data_from_source_if_not_already_loaded(self, data_source_class):
        if data_source_class not in self._data:
            self._data[data_source_class] = self._data_sources[data_source_class].data

    def load(self, *args, **kwargs):
        pass

    def _get_id_by_column_values(self, table, column_values):
        primary_key_columns = [pk_col for pk_col in table.primary_key]
        select_stmt = select(primary_key_columns)
        for col, value in column_values.iteritems():
            select_stmt = select_stmt.where(col == value)

        with CCLEDatabase().begin() as connection:
            return connection.execute(
                self._attach_where_clause_for_current_dataset_to_statement(
                    table,
                    select_stmt
                )
            ).scalar()

    def _get_value_or_none_if_equals_null(self, value):
        try:
            if math.isnan(value):
                return None
        except TypeError:
            pass
        if value == self._null_value:
            return None
        return value

    def _insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self, table, values_by_column, where_columns=None):

        if not where_columns:
            where_columns = list()

        updated_rows = 0
        if len(where_columns) > 0:
            select_stmt = select([pk_col for pk_col in table.primary_key])
            for column in where_columns:
                select_stmt = select_stmt.where(column == values_by_column[column])

            with CCLEDatabase().begin() as connection:
                matching_ids = connection.execute(
                    self._attach_where_clause_for_current_dataset_to_statement(table, select_stmt)
                )

                base_update = table.update().values(values_by_column)
                for row in self._iterate_through_result_set(matching_ids):
                    updated_rows += 1
                    keyed_update = base_update
                    for primary_key in table.primary_key:
                        keyed_update = keyed_update.where(primary_key == row[primary_key])
                    connection.execute(keyed_update)

        if updated_rows == 0:
            with CCLEDatabase().begin() as connection:
                if getattr(table.c, 'DataSets_idDataSet', None) is not None:
                    values_by_column.update({'DataSets_idDataSet': self._dataset_id})
                connection.execute(table.insert().values(values_by_column))

    def _attach_where_clause_for_current_dataset_to_statement(self, table, statement):
        if getattr(table.c, 'DataSets_idDataSet', None) is not None:
            statement = statement.where(table.c.DataSets_idDataSet == self._dataset_id)
        return statement

    @classmethod
    def _iterate_through_result_set(cls, result_set):
        while result_set:
            row = result_set.fetchone()
            if row is None:
                break
            yield row
