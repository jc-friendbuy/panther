library(shiny)
source('src/visualization_config.R')

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Prototipo de visualización de datos"),

    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("visualization.select",
                        label = h3("Visualización"),
                        choices = list("Vis 1" = 1, "Vis 2" = 2, "Vis 3" = 3),
                        selected = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("visualization")
        )
    )
))
