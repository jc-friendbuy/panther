from contextlib import contextmanager
from sqlalchemy import MetaData, Table
from setup.database.etl.common.singleton import Singleton
from setup.database.metadata.database_engine import DatabaseEngine


class CCLEDatabase(object):

    __metaclass__ = Singleton

    def __init__(self):
        self._db_engine = DatabaseEngine()
        self._metadata = MetaData()
        self._metadata.reflect(bind=self._db_engine.engine)

        self.cancer_cell_lines = self._get_table('CancerCellLines')
        self.cell_line_sites = self._get_table('CellLineSites')
        self.cell_line_sources = self._get_table('CellLineSources')
        self.chromosomes = self._get_table('Chromosomes')
        self.data_sets = self._get_table('DataSets')
        self.drug_response_doses = self._get_table('DrugResponseDoses')
        self.drug_responses = self._get_table('DrugResponses')
        self.expression_arrays = self._get_table('ExpressionArrays')
        self.genes = self._get_table('Genes')
        self.gene_copy_numbers = self._get_table('GeneCopyNumbers')
        self.gene_expressions = self._get_table('GeneExpressions')
        self.gene_transcripts = self._get_table('GeneTranscripts')
        self.snp_arrays = self._get_table('SNPArrays')
        self.therapy_compounds = self._get_table('TherapyCompounds')

    def _get_table(self, table_name):
        return Table(table_name, self._metadata, autoload=True)

    @contextmanager
    def begin(self):
        connection = self._db_engine.engine.connect()
        transaction = connection.begin()
        try:
            yield connection
            transaction.commit()
        except:
            transaction.rollback()
            raise
        finally:
            connection.close()
