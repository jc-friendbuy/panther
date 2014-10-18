library(shiny)
library(shinyRGL)
source('visualization_config.R')

shinyUI(fluidPage(
  
  titlePanel("Prototipo de visualización de datos"),
  
  sidebarLayout(
    sidebarPanel(
      submitButton("Mostrar")
    ),
    
    mainPanel(
      uiOutput('output.plots')
    ),
    position = "right"
  )
))
