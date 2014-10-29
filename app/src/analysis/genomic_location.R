source('src/data/db.R')

GetGenomicLocationOrderedGeneticProfile <- function() {
  data <- GetAll()
  
  # Replace X and Y chromosome entries with '23' so that conversion to numeric
  # places them at the end of the chromosome order
  data$chromosome[data$chromosome %in% c('X', 'Y')] <- '23'
  data$numeric.chromosome <- as.numeric(data$chromosome)
  
  ordered <- with(data, order(numeric.chromosome, 
                              chromosomeLocationStart, 
                              chromosomeLocationEnd))
  data[ordered, ]
}

GenomicLocations <- function() {
  data <- GetGenomicLocationOrderedGeneticProfile()
  x <- 1:nrow(data)
  
  list(
    list(
      graph.type = "plot",
      visualization = function() {
        y <- data$snpCopyNumber2Log2
        ylim <- c(min(y), max(y))
        
        plot(x = x,
             y = y,
             xlab = 'Genomic location',
             ylab = 'Gene Copy Number',
             main = 'Gene Copy Number by Genomic Location',
             type = 'p',
             ylim = ylim,
             pch = 20)
      }
    ), 
    list(
      graph.type = "plot",
      visualization = function() {
        y <- data$quantileNormalizedRMAExpression
        ylim <- c(min(y), max(y))
        
        plot(x = x,
             y = y,
             xlab = 'Genomic location',
             ylab = 'Gene Expression',
             main = 'Gene Expression by Genomic Location',
             type = 'p',
             ylim = ylim,
             pch = 20)
      }
    )
  )
}

GetGenomicLocationPlots <- function(data) {
  x <- 1:nrow(data)
  list(
    list(
      graph.type = "plot",
      visualization = function() {
        y <- data$snpCopyNumber2Log2
        ylim <- c(min(y), max(y))
        
        plot(x = x,
             y = y,
             xlab = 'Genomic location',
             ylab = 'Gene Copy Number',
             main = 'Gene Copy Number by Genomic Location',
             type = 'p',
             ylim = ylim,
             pch = 20)
      }
    ), 
    list(
      graph.type = "plot",
      visualization = function() {
        y <- data$quantileNormalizedRMAExpression
        ylim <- c(min(y), max(y))
        
        plot(x = x,
             y = y,
             xlab = 'Genomic location',
             ylab = 'Gene Expression',
             main = 'Gene Expression by Genomic Location',
             type = 'p',
             ylim = ylim,
             pch = 20)
      }
    )
  )
}

GenomicLocationsByCellLine <- function(line, data) {
  line.data <- data[with(data, ccleName == line), ]
  x <- 1:nrow(line.data)
  
}
