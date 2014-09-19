library(shiny)
library(shinyRGL)
source('visualization_config.R')

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel("Prototipo de visualización de datos"),

    sidebarLayout(
        sidebarPanel(
            selectInput("visualization.select",
                        label = h3("Visualización"),
                        choices = GetVisualizationFunctionChoices(),
                        selected = 2),
            actionButton("btn.display.selected.visualization",
                         label = "Mostrar")
        ),

        mainPanel(
            plotOutput("visualization"),
            webGLOutput("vis3d")
        ),
        position = "right"
    )
))
