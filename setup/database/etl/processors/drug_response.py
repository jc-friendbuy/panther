from setup.database.etl.data_sources.drug_information import DrugInformationDataSource
from setup.database.etl.data_sources.drug_response import DrugResponseDataSource
from setup.database.etl.processors.etlprocessor import ETLProcessor
from setup.database.metadata.database import CCLEDatabase


class DrugResponseETLProcessor(ETLProcessor):

    def __init__(self, dataset_id):
        super(self.__class__, self).__init__(dataset_id, [DrugInformationDataSource, DrugResponseDataSource])
        self.drug_responses = CCLEDatabase().drug_responses
        self.drug_response_doses = CCLEDatabase().drug_response_doses
        self.therapy_compounds = CCLEDatabase().therapy_compounds

    def load(self):
        for row_number, row in self.extract(DrugInformationDataSource).iterrows():
            self._load_drug_information(row)

    def _load_drug_information(self, row):
        chromosome = self._get_value_or_none_if_equals_null(row['CHR'])
        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.chromosomes, {
                self.chromosomes.c.name: chromosome,
            },
            [self.chromosomes.c.name]
        )
        chromosome_id = self._get_chromosome_id_from_name(chromosome)

        egid = self._get_value_or_none_if_equals_null(row['EGID'])
        symbol = self._get_value_or_none_if_equals_null(row['SYMBOL'])
        loc_start = self._get_value_or_none_if_equals_null(row['CHRLOC'])
        loc_end = self._get_value_or_none_if_equals_null(row['CHRLOCEND'])

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.genes, {
                self.genes.c.egid: egid,
                self.genes.c.symbol: symbol,
                self.genes.c.chromosomeLocStart: loc_start,
                self.genes.c.chromosomeLocEnd: loc_end,
                self.genes.c.Chromosomes_idChromosome: chromosome_id
            },
            [self.genes.c.egid]
        )

    def _load_drug_response(self, row):
        chromosome = self._get_value_or_none_if_equals_null(row['CHR'])
        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.chromosomes, {
                self.chromosomes.c.name: chromosome,
            },
            [self.chromosomes.c.name]
        )
        chromosome_id = self._get_chromosome_id_from_name(chromosome)

        egid = self._get_value_or_none_if_equals_null(row['EGID'])
        symbol = self._get_value_or_none_if_equals_null(row['SYMBOL'])
        loc_start = self._get_value_or_none_if_equals_null(row['CHRLOC'])
        loc_end = self._get_value_or_none_if_equals_null(row['CHRLOCEND'])

        self._insert_or_update_table_in_current_dataset_with_values_based_on_where_columns(
            self.genes, {
                self.genes.c.egid: egid,
                self.genes.c.symbol: symbol,
                self.genes.c.chromosomeLocStart: loc_start,
                self.genes.c.chromosomeLocEnd: loc_end,
                self.genes.c.Chromosomes_idChromosome: chromosome_id
            },
            [self.genes.c.egid]
        )

    def _get_chromosome_id_from_name(self, chromosome_name):
        return self._get_primary_key_by_column_values(self.chromosomes, {
            self.chromosomes.c.name: chromosome_name}
        )
