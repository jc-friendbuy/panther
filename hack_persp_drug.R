the.data <- read.csv('data/drug.csv')
the.data <- data.table(the.data)
x <- the.data$CCLE.Cell.Line.Name
y <- the.data$Compound
z <- the.data$IC50..uM.
z[is.na(z)] <- -1

open3d()
persp3d(x, y, z)
