library(data.table)
the.data <- read.csv('data/drug.csv')
the.data <- data.table(the.data)

setkey(the.data, Compound)


# x is the x coordinate vector
# y is the y coordinate vector
# z is a dim(x) x dim(y) matrix with the data that will be plotted on the persp
open3d()
persp3d(x, y, z)
