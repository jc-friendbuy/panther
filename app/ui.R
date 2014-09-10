library(shiny)
source('visualization_config.R')

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel("Prototipo de visualización de datos"),

    sidebarLayout(
        sidebarPanel(
            selectInput("visualization.select",
                        label = h3("Visualización"),
                        choices = GetVisualizationFunctionChoices(),
                        selected = 2)
        ),

        mainPanel(
            plotOutput("visualization")
        )
    )
))
