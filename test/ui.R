library(shiny)
library(shinyRGL)

shinyUI(fluidPage(
  
  titlePanel("PRUEBAS"),
  
  sidebarLayout(
    sidebarPanel(
      submitButton("Mostrar")
    ),
    
    mainPanel(
      plotOutput('plot')
    ),
    position = "right"
  )
))
