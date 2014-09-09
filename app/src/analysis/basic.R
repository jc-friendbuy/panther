SelectSimpleDrugSubset <- function() {
    all.data <- data$Load()
    all.data
    source.data <- all.data$drug.response[which(all.data$drug.response$Compound == "TAE684"), ]
    source.data
    x <- source.data[["Primary.Cell.Line.Name"]][1:data$kMaxRows]
    y <- source.data[["EC50..uM."]][1:data$kMaxRows]
    usable <- complete.cases(x, y)
    usable
    list(
        fun = "plot",
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
