library(shiny)
library(shinyRGL)
source('visualization_config.R')

shinyUI(fluidPage(
  
  titlePanel("Prototipo de visualización de datos"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("visualization.select",
                  label = h3("Visualización"),
                  choices = GetVisualizationFunctionChoices(),
                  selected = 1),
      submitButton("Mostrar")
    ),
    
    mainPanel(
      uiOutput('visualization.output')
    ),
    position = "right"
  )
))
