kDataPath <- '/Users/jc/Projects/panther/data/'
kMaxRows <- 500

Load <- function() {
    list(
         #mRNA.expression = read.table(paste(kDataPath, 'expression.gct')),
         #copy.number = read.table(paste(kDataPath, 'copynumber.txt')),
         drug.response = read.csv(paste0(kDataPath, 'drug.csv'))
    )
}
