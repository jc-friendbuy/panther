import ipdb
from setup.database.etl.common import data_readers as dr

def load():
    copy_number = dr.CopyNumberReader().read('copynumber.txt')
    drug_response = dr.DrugResponseReader().read('drug.csv')
    gene_expression = dr.GeneExpressionReader().read('expression.gct')
    line_info = dr.CellLineInformationReader().read('lines.csv')
    ipdb.set_trace()
