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

AEW541 <- function() {
    all.data <- Load()
    source.data <- all.data$drug.response[which(all.data$drug.response$Compound == "AEW541"), ]
    x <- source.data[["EC50..uM."]][1:kMaxRows]
    usable <- complete.cases(x)
    list(
        graphing.function.name = "hist",
        args = list(
            x[usable],
            xlab = "EC50 (uM)",
            main = "EC50 by Primary Cell Line - Histogram",
            pch = 16
        )
    )
}

Volcano <- function() {
    x <- 10*(1:nrow(volcano))
    y <- 10*(1:ncol(volcano))
    list(
        graphing.function.name = "image",
        args = list(
            x,
            y,
            volcano,
            col = terrain.colors(100),
            main = "Volcano test"
        )
    )
}
