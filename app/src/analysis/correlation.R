source('src/data/db.R')
library(shiny)

CorrelationsByGene <- function() {
  ApplyByGene(function(data, gene.label) {
    cor(data$quantileNormalizedRMAExpression, data$snpCopyNumber2Log2)
  })
}

CorrelationForGene <- function(symbol) {
  ApplyForGene(symbol, function(data, gene.label) {
    cor(data$quantileNormalizedRMAExpression, data$snpCopyNumber2Log2)
  })[[symbol]]
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

CorrelationFits <- function() {
  selected.gene.symbols <- c('BEND7', 'ORAOV1', 'PLD5')
  lapply(selected.gene.symbols, function(gene.symbol) {
    force(gene.symbol)
    list(
      graph.type = "plot",
      visualization = function() {
        data <- GetDataByGeneSymbol(gene.symbol)
        x <- data$snpCopyNumber2Log2
        y <- data$quantileNormalizedRMAExpression
        corr <- CorrelationForGene(gene.symbol)
        print(corr)
        plot(x = x,
             y = y,
             xlab = 'Gene Copy Number',
             ylab = 'Gene Expression',
             main = paste0(
               'GCN and GE Correlation for ',
               gene.symbol,
               '(',
               format(round(corr, 4), nsmall = 4),
               ').'))
        model <- lm(y ~ x)
        abline(model)
      }
    )
  })
}

SideBySideCNAndGE <- function() {
  selected.gene.symbols <- c('BEND7', 'ORAOV1', 'PLD5')
  lapply(selected.gene.symbols, function(gene.symbol) {
    force(gene.symbol)
    list(
      graph.type = "plot",
      visualization = function() {
        data <- GetDataByGeneSymbol(gene.symbol)
        cn <- data$snpCopyNumber2Log2
        ge <- data$quantileNormalizedRMAExpression
#         cn.normalization.value <- mean(ge) / 2
        cn.normalization.value <- 0
        normalized.cn <- cn + cn.normalization.value

        plot.title <- paste0(
          'Expression (red) and Copy Number + ',
          format(round(cn.normalization.value, 2), nsmall = 2),
          ' (green) for ',
          gene.symbol)

        x <- 1:length(cn)
        ylim <- c(min(c(min(normalized.cn), min(ge))),
                  max(c(max(normalized.cn), max(ge))))

        plot(x = x,
             y = ge,
             col='red',
             xlab = 'Cancer Cell Line (#)',
             type = 'p',
             main = plot.title,
             ylim = ylim,
             pch = 20)
        lines(x = x, y = ge, col = 'red', lwd = 2)
        abline(mean(ge), 0, col = 'red', lwd = 2)
        text(x[ceiling(length(x) / 2)], mean(ge), label = 'Mean GE' )
        lines(x = x, y = normalized.cn, col='green', lwd = 2)
        points(x = x, y = normalized.cn, col='green', pch = 20)
        abline(mean(normalized.cn), 0, col = 'green', lwd = 2)
        text(x[ceiling(length(x) / 2)], mean(normalized.cn), label = 'Mean CN' )
      }
    )
  })
}
