source('src/data/db.R')
library(shiny)

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

CorrelationHistogram <- function(data) {
  correlations.by.gene <- CorrelationsByGene()
  list(
    list(
      graph.type = "hist",
      visualization = function() {
        hist(x = unlist(correlations.by.gene),
             xlab = "Correlation",
             ylab = "Frequency",
             main = "Copy Number, Expression Correlation")
      }
    )
  )
}

CorrelationPlots <- function() {
  correlations.by.gene <- CorrelationsByGene()
  genes.to.plot <- c('BEND7', 'ORAOV1', 'PLD5')
  lapply(genes.to.plot, GetCorrelationPlot)
 
#   plot.list <- list()
#   for (index in 1:length(genes.to.plot)) {
#     individual.plot <- list(
#       graph.type = 'plot',
#       visualization = function() {
#         gene.symbol <- genes.to.plot[index]
#         data <- GetDataByGeneSymbol(gene.symbol)
#         x <- data$snpCopyNumber2Log2
#         y <- data$quantileNormalizedRMAExpression
#         corr <- correlations.by.gene[[gene.symbol]]
#         plot(x = x,
#              y = y,
#              xlab = 'Gene Copy Number',
#              ylab = 'Gene Expression',
#              main = paste0(
#                'GCN and GE Correlation for ', 
#                gene.symbol, 
#                '(', 
#                format(round(corr, 4), nsmall = 4),
#                ').')
#              )
#         model <- lm(y ~ x)
#         abline(model)
#       }
#     )
#     plot.list[[length(plot.list) + 1]] <- individual.plot
#   }
#   plot.list
}

GetCorrelationPlot <- function(gene.symbol) {
  list (
    graph.type = "plot",
    visualization = function () {
      data <- GetDataByGeneSymbol(gene.symbol)
      x <- data$snpCopyNumber2Log2
      y <- data$quantileNormalizedRMAExpression
      corr <- correlations.by.gene[[gene.symbol]]
      plot(x = x,
           y = y,
           xlab = 'Gene Copy Number',
           ylab = 'Gene Expression',
           main = paste0(
             'GCN and GE Correlation for ', 
             gene.symbol, 
             '(', 
             format(round(corr, 4), nsmall = 4),
             ').')
      )
      model <- lm(y ~ x)
      abline(model)
    }
  )
}

