kDataPath <- '/Users/jc/Projects/panther/data/'

CopyNumber <- function () {
  # Read the gene copy number data file
  read.table(paste0(kDataPath, 'copynumber.txt'), header = T)
}

DrugResponse <- function () {
  # Read the drug response data file
  read.csv(paste0(kDataPath, 'drug.csv'))
}

Expression <- function () {
  # Read the gene mRNA expression data file
  read.table(paste0(kDataPath, 'expression.gct'),
             header = T, 
             skip = 2,
             skipNul = T)
}

LineData <- function () {
  # Read the cancer cell line data file
  read.table(paste0(kDataPath, 'lines.txt'), header = T)
}
