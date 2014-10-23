package.list <- c(
  'reshape2',
  'rgl',
  'RMySQL',
  'shiny',
  'shinyRGL'
  )
install.packages(package.list)
setwd('../app/')

print('Para correr el programa, debe ejecutar `source("server.R")` y luego `shiny::runApp("app")`')
