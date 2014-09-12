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

Surface <- function() {
  x <- seq(-10, 10, length= 30)
  y <- x
  f <- function(x, y) { r <- sqrt(x^2+y^2); 10 * sin(r)/r }
  z <- outer(x, y, f)
  z[is.na(z)] <- 1
  list(
    graphing.function.name = "persp",
    args = list(
      x = x,
      y = y,
      z = z,
      theta = 30,
      phi = 30,
      expand = 0.5,
      col = "lightblue",
      main = "Surface test"
    )
  )
}
