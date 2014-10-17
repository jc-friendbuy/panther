source('src/analysis/basic.R')
source('src/analysis/correlation.R')

visualization.list <- list(
  # TAE684 = TAE684,
  # AEW541 = AEW541,
  # Volcano = Volcano,
  # Surface = Surface
  '--' = '',
  CorrelationHistogram = CorrelationHistogram
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
