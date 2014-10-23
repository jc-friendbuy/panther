package.list <- c(
  'reshape2',
  'rgl',
  'RMySQL',
  'shiny',
  'shinyRGL'
  )
install.packages(package.list)

print('Asegúrese de que el directorio de trabajo esté establecido al directorio `app` (por ejemplo: setwd("~/Projects/panther/app/")')
print('Luego, para correr el programa, debe ejecutar `source("server.R")` y luego `shiny::runApp()`')
