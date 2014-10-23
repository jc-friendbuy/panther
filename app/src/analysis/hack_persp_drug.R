library(data.table)

# Drug data - not ready
# drug.data <- data.table(read.csv('data/drug.csv'))
# # Assign 100 as the IC50 of NA values (an abnormally high number)
# drug.data[is.na(IC50..uM.),IC50..uM. := 100]


# GENE EXPRESSION



# Expression data - read only from 500 genes
kNumGenes <- 500
expression.data <- read.table('data/expression.gct',
                                          header = T,
                                          skip = 2,
                                          sep = '\t',
                                          nrows = kNumGenes)


x <- 1:kNumGenes
# y <- 1:(dim(expression.data)[2] - 2)
# z <- data.matrix(expression.data[1:kNumGenes, 3:dim(expression.data)[2]])
# Select only 60 cell lines (for demo purposes only)
y <- 1:60
# Remove the first two columns (name and description) from the data to graph it
z <- data.matrix(expression.data[1:kNumGenes, 3:62])


# x is the x coordinate vector
# y is the y coordinate vector
# z is a dim(x) x dim(y) matrix with the data that will be plotted on the persp

# Interactive 3d perspective
open3d()
persp3d(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Nivel expresion",
      col = 'lightblue')

# Pre-rendered and non-dynamic 3d perspective.
persp(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Nivel expresion",
      col = 'lightblue', theta = 15, phi = 45)



# COPY NUMBER


# Copy number data - read only from kCopyNumGenes genes
kCopyNumGenes <- 1500
copy.number.data <- read.table('data/copynumber.txt',
                                          header = T,
                                          sep = '\t',
                                          nrows = kCopyNumGenes)

x <- 1:kCopyNumGenes
y <- 1:60
z <- data.matrix(copy.number.data[1:kCopyNumGenes, 6:65])
# x is the x coordinate vector
# y is the y coordinate vector
# z is a dim(x) x dim(y) matrix with the data that will be plotted on the persp

# Interactive 3d perspective
open3d()
persp3d(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Copy Number",
      col = 'lightblue')

# Pre-rendered, non dynamic 3d perspective.
persp(x, y, z, xlab = "Gen", ylab = "Linea", zlab = "Copy Number",
      col = 'lightblue', theta = 15, phi = 45)
