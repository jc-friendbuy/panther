source('src/analysis/basic.R')
source('src/analysis/correlation.R')

visualization.list <- list(
  '--' = '',
  CorrelationHistogram = CorrelationHistogram,
  CorrelationFits = CorrelationFits,
  SideBySideCNAndGE = SideBySideCNAndGE
#   ExpressionAndCopyNumberPerspectives = ExpressionAndCopyNumberPerspectives
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
