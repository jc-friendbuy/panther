source('src/data/db.R')

GenomicLocations <- function() {
  data <- GetAll()
  x.y.chromosomes.to.replace <- data$chromosome %in% c('X', 'Y')
  data$chromosome[x.y.chromosomes.to.replace] <- '23'
  data$numeric.chromosome <- as.numeric(data$chromosome)
  
  data$normalized.genomic.location <- paste0(
    data$numeric.chromosome, data$chromosomeLocationStart
  )
  x <- data$normalized.genomic.location
  
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
