library(shiny)
library(shinyRGL)
source('visualization_config.R')

shinyServer(function(input, output) {
  
  output$output.plots <- renderUI({
    
    computed.visualizations <- ExecuteVisualization(
      input$visualization.select
    )
        
    # Execute each visualization and render the results to the appropriate output element.
    current.id <- 0
    lapply(computed.visualizations, function(visualization) {
      current.id <- current.id + 1
      render.function <- SelectRenderingFunction(visualization$graph.type)
      visualization.id <- paste0('visualization', current.id)
      output[[visualization.id]] <- render.function(visualization$visualization())
    })
  })
})

SelectRenderingFunction <- function(visualization.function) {
  switch(visualization.function,
    plot = renderPlot,
    hist = renderPlot,
    plot3d = renderWebGL
  )
}


ExecuteVisualization <- function(visualization) {
  visualization.to.execute <- visualization.list[[as.integer(visualization)]]
  visualization.to.execute()
}
