library(shiny)
library(shinyRGL)
source('visualization_config.R')

shinyServer(function(input, output) {
  
  output$visualization.output <- renderUI({
    
    computed.visualizations <- ExecuteVisualization(
      input$visualization.select
    )

    lapply(computed.visualizations, function(visualization) {
      render.function <- SelectRenderingFunction(visualization$graph.type)
      render.function(visualization$visualization())
    })
  })
})

SelectRenderingFunction <- function(visualization.function) {
  switch(visualization.function,
    plot = renderPlot,
    hist = renderPlot,
    plot3d = renderWebGL,
    h3 = h3
  )
}

ExecuteVisualization <- function(visualization) {
  visualization.index <- as.integer(visualization)
  if (visualization.index > 1) {
    visualization.to.execute <- visualization.list[[visualization.index]]
    visualization.to.execute()
  }
}
