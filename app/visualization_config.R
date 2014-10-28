source('src/analysis/basic.R')
source('src/analysis/correlation.R')
source('src/analysis/genomic_location.R')

visualization.list <- list(
  '--' = '',
  'Correlation Histogram' = CorrelationHistogram,
  'Linear fits to correlation indexes' = CorrelationFits,
  'Copy Number and Gene Expression relationship' = SideBySideCNAndGE,
  'Genomic location analysis' = GenomicLocations
)

GetVisualizationFunctionChoices <- function() {
  vis.names <- names(visualization.list)
  result <- list()
  for (i in 1:length(vis.names)) {
    name <- vis.names[[i]]
    result[[name]] <- i
  }
  result
}
