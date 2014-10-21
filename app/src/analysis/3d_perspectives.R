source('src/data/db.R')
library(rgl)
library(shinyRGL)
library(reshape2)

GetExpressionCopyNumberAndCCLEName <- function() {
  ApplyByGene(function(data, gene.label) {
    print(paste("Computing for", gene.label))
    list(data$quantileNormalizedRMAExpression, data$snpCopyNumber2Log2, data$ccleName)
  })
}

ExpressionAndCopyNumberPerspectives <- function() {
  list(
    list(
      graph.type = "plot3d",
      visualization = function () {
        all.data <- GetAll()
        all.data$symbol <- factor(all.data$symbol)
        all.data$ccleName <- factor(all.data$ccleName)
        x <- 1:length(levels(all.data$symbol))
        y <- 1:length(levels(all.data$ccleName))
        
        gene.expression.data <- all.data[, c('symbol', 'ccleName', 'quantileNormalizedRMAExpression')]
        gene.expression.z <- dcast(gene.expression.data, symbol ~ ccleName)
        
        copy.number.data <- all.data[, c('symbol', 'ccleName', 'snpCopyNumber2Log2')]
        copy.number.z <- dcast(copy.number.data, symbol ~ ccleName)
        z <- gene.expression.z[, 2:ncol(gene.expression.z)]
        
        light3d()
        surface3d(x = x,
                  y = y,
                  z = data.matrix(z),
                  ylab = 'Gene symbol',
                  xlab = 'Cell Line Name',
                  zlab = 'Gene expression level',
                  col = 'blue'
        )
      }
    )
  )
}
  
#   list(
#     list(
#       graph.type = "plot3d",
#       visualization = function() {
#         lights3d()
#         surface3d(x, y, gene.expression.z, 
#                   xlab = 'Gene symbol',
#                   ylab = 'Cell Line Name',
#                   zlab = 'Gene expression level',
#                   col = 'blue')
#         surface3d(x, y, copy.number.z,
#                   zlab = 'Gene expression level',
#                   col = 'blue')
#       }
#     )
#   )
# }
# 
# # Drug data - not ready
# # drug.data <- data.table(read.csv('data/drug.csv'))
# # # Assign 100 as the IC50 of NA values (an abnormally high number)
# # drug.data[is.na(IC50..uM.),IC50..uM. := 100]
# 
# 
# # GENE EXPRESSION
# 
# 
# 
# # Expression data - read only from 500 genes
# kNumGenes <- 500
# expression.data <- read.table('data/expression.gct',
#                               header = T,
#                               skip = 2,
#                               sep = '\t',
#                               nrows = kNumGenes)
# 
# 
# x <- 1:kNumGenes
# # y <- 1:(dim(expression.data)[2] - 2)
# # z <- data.matrix(expression.data[1:kNumGenes, 3:dim(expression.data)[2]])
# # Select only 60 cell lines (for demo purposes only)
# y <- 1:60
# # Remove the first two columns (name and description) from the data to graph it
# z <- data.matrix(expression.data[1:kNumGenes, 3:62])
# 
# 
# # x is the x coordinate vector
# # y is the y coordinate vector
# # z is a dim(x) x dim(y) matrix with the data that will be plotted on the persp
# 
# # Interactive 3d perspective
# open3d()
# persp3d(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Nivel expresion",
#         col = 'lightblue')
# 
# # Pre-rendered and non-dynamic 3d perspective.
# persp(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Nivel expresion",
#       col = 'lightblue', theta = 15, phi = 45)
# 
# 
# 
# # COPY NUMBER
# 
# 
# # Copy number data - read only from kCopyNumGenes genes
# kCopyNumGenes <- 1500
# copy.number.data <- read.table('data/copynumber.txt',
#                                header = T,
#                                sep = '\t',
#                                nrows = kCopyNumGenes)
# 
# x <- 1:kCopyNumGenes
# y <- 1:60
# z <- data.matrix(copy.number.data[1:kCopyNumGenes, 6:65])
# # x is the x coordinate vector
# # y is the y coordinate vector
# # z is a dim(x) x dim(y) matrix with the data that will be plotted on the persp
# 
# # Interactive 3d perspective
# open3d()
# persp3d(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Copy Number",
#         col = 'lightblue')
# 
# # Pre-rendered, non dynamic 3d perspective.
# persp(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Copy Number",
#       col = 'lightblue', theta = 15, phi = 45)
# 
