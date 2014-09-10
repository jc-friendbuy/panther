library(shiny)
source('src/visualization_config.R')

shinyServer(function(input, output) {
    # Compute the results of the requested visualization and determine
    # the appropriate render function so it can be displayed on the UI.
    computed.visualization <- ExecuteVisualization(
      input$visualization.select
    )

    rendering.function <- SelectRenderingFunction(
      computed.visualization$graphing.function.name
    )

    output$visualization <- rendering.function({
        do.call(
          computed.visualization$graphing.function.name,
          computed.visualization$args
        )
    })
})

SelectRenderingFunction <- function(visualization.function) {
  switch(visualization.function,
    plot = renderPlot
  )
}

ExecuteVisualization <- function(visualization) {
  visualization.list[[visualization]]()
}
