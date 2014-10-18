library(rgl)
library(shiny)
library(shinyRGL)
library(reshape2)
source('../app/src/data/db.R')

shinyServer(function(input, output) {
  
  # Note this is executed on page load and every time the submit button is clicked.
  output$plot <- renderWebGL({
#     visualization.id <- paste0('visualization', current.id)
#     output[[visualization.id]] <- render.function(visualization$visualization())
    all.data <- GetAll()
    all.data$symbol <- factor(all.data$symbol)
    all.data$ccleName <- factor(all.data$ccleName)
    y <- 1:length(levels(all.data$symbol))
    x <- 1:length(levels(all.data$ccleName))
    
    gene.expression.data <- all.data[, c('symbol', 'ccleName', 'quantileNormalizedRMAExpression')]
    gene.expression.z <- dcast(gene.expression.data, symbol ~ ccleName)
    
    copy.number.data <- all.data[, c('symbol', 'ccleName', 'snpCopyNumber2Log2')]
    copy.number.z <- dcast(copy.number.data, symbol ~ ccleName)
    z <- gene.expression.z[, 2:ncol(gene.expression.z)]
    
    light3d()
    persp(x = y,
              y = x,
              z = data.matrix(z),
              ylab = 'Gene symbol',
              xlab = 'Cell Line Name',
              zlab = 'Gene expression level',
              col = 'blue'
    )
  })
})
