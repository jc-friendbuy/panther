
kDataPath <- '/Users/jc/Projects/panthera/data/'
kMaxRows <- 500

Load <- function() {
    data.dictionary <- list(
         #mRNA.expression = read.table(paste(kDataPath, 'expression.csv')),
         #copy.number = read.table(paste(kDataPath, 'copynumber.txt')),
         drug.response = read.csv(paste0(kDataPath, 'drug.csv'))
    )    
}
