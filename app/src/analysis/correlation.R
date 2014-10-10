source('src/data/db.R')

# CorrelationHistogram <- function() {
#   all.data <- GetAll()
#   all.data$symbol <- factor(all.data$symbol)
#   all.data$ccleName <- factor(all.data$ccleName)
#   
#   correlations <- numeric()
#   for (gene in levels(all.data$symbol)) {
#     print(paste("Computing for", gene))
#     gene.data <- all.data[all.data$symbol == gene, ]
#     correlations <- c(correlations, cor(
#       gene.data$quantileNormalizedRMAExpression,
#       gene.data$snpCopyNumber2Log2))
#   }
#   list(
#     graphing.function.name = "hist",
#     args = list(
#       x = correlations,
#       xlab = "Correlation",
#       ylab = "Frequency",
#       main = "Copy Number, Expression Correlation"
#     )
#   )
# }

CorrelationsByGene <- function() {
  ApplyByGene(function(data, gene.label) {
    print(paste("Computing for", gene.label))
    cor(data$quantileNormalizedRMAExpression, data$snpCopyNumber2Log2)
  })
}

CorrelationHistogram <- function() {
  correlations.by.gene <- CorrelationsByGene()
  
  list(
    graphing.function.name = "hist",
    args = list(
      x = unlist(correlations.by.gene),
      xlab = "Correlation",
      ylab = "Frequency",
      main = "Copy Number, Expression Correlation"
    )
  )
}

CorrelationPlots <- function() {
  
}

