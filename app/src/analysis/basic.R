source('src/data/data.R')

TAE684 <- function() {
    all.data <- Load()
    source.data <- all.data$drug.response[which(all.data$drug.response$Compound == "TAE684"), ]
    x <- source.data[["Primary.Cell.Line.Name"]][1:kMaxRows]
    y <- source.data[["EC50..uM."]][1:kMaxRows]
    usable <- complete.cases(x, y)
    list(
        graphing.function.name = "plot",
        args = list(
            x = x[usable],
            y = y[usable],
            xlab = "Primary Cell Line",
            ylab = "EC50 (uM)",
            main = "EC50 by Primary Cell Line",
            pch = 16
        )
    )
}
