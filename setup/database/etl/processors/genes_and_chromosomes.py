from sqlalchemy import select
from setup.database.etl.data_sources.copy_number import CopyNumberDataSource
from setup.database.etl.processors.processor import Processor
from setup.database.metadata.database import CCLEDatabase


class GeneAndChromosomeProcessor(Processor):

    def __init__(self):
        super(self.__class__, self).__init__([CopyNumberDataSource])
        self.chromosomes = CCLEDatabase().chromosomes
        self.genes = CCLEDatabase().genes

    def load(self, dataset_id):
        self._extract_data_from_source_if_not_already_loaded(CopyNumberDataSource)
        for row_number, row in self._data[CopyNumberDataSource].iterrows():
            self._load_chromosome_and_gene(row)

    def _load_chromosome_and_gene(self, row):
        chromosome = row['CHR']
        chromosome_id = self._insert_chromosome_from_name_if_not_present_and_get_id(chromosome)

        egid = row['EGID']
        symbol = row['SYMBOL']
        loc_start = row['CHRLOC']
        loc_end = row['CHRLOCEND']

        self._insert_gene_if_not_present(egid, symbol, loc_start, loc_end, chromosome_id)

    def _insert_chromosome_from_name_if_not_present_and_get_id(self, chromosome_name):
        stored_chromosome = self._get_chromosome_from_name(chromosome_name)

        if not stored_chromosome:
            with CCLEDatabase().begin() as connection:
                connection.execute(
                    self.chromosomes.insert().values(
                        name=chromosome_name,
                    )
                )
            stored_chromosome = self._get_chromosome_from_name(chromosome_name)

        return stored_chromosome[self.chromosomes.c.idChromosome]

    def _get_chromosome_from_name(self, chromosome_name):
        with CCLEDatabase().begin() as connection:
            existing_chromosome = connection.execute(
                select([self.chromosomes])
                .where(self.chromosomes.c.name == chromosome_name)
            ).first()
        return existing_chromosome

    def _insert_gene_if_not_present(self, egid, symbol, loc_start, loc_end, chromosome_id):
        with CCLEDatabase().begin() as connection:
            existing_gene = connection.execute(
                select([self.genes])
                .where(self.genes.c.egid == egid)
            ).first()

            if not existing_gene:
                connection.execute(
                    self.genes.insert().values(
                        egid=egid,
                        symbol=symbol,
                        chromosomeLocStart=loc_start,
                        chromosomeLocEnd=loc_end,
                        Chromosomes_idChromosome=chromosome_id
                    )
                )
