from sqlalchemy import select
from setup.database.etl.data_sources.copy_number import CopyNumberDataSource
from setup.database.metadata.database import CCLEDatabase


class GeneAndChromosomeProcess(object):

    def __init__(self):
        self.chromosomes = CCLEDatabase().chromosomes
        self.genes = CCLEDatabase().genes

    def run(self):
        copy_number_data = CopyNumberDataSource().data
        for row in copy_number_data.iterrows():
            chromosome = row[2]
            chromosome_id = self._insert_chromosome_from_name_if_not_present_and_get_id(chromosome)

            egid = row[0]
            symbol = row[1]
            loc_start = row[3]
            loc_end = row[4]

            self._insert_gene_if_not_present(egid, symbol, loc_start, loc_end, chromosome_id)

    def _insert_chromosome_from_name_if_not_present_and_get_id(self, chromosome_name):
        stored_chromosome = self._get_chromosome_from_name(chromosome_name)

        if not stored_chromosome:
            with CCLEDatabase().begin() as connection:
                chromosome_id = connection.execute(
                    self.chromosomes.insert().values(
                        name=chromosome_name,
                    ).returning(self.chromosomes.idChromosome)
                )
        else:
            chromosome_id = stored_chromosome[self.chromosomes.c.idChromosome]

        return chromosome_id

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
