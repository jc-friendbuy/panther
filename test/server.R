library(shiny)
library(shinyRGL)
library(rgl)
library(shinyRGL)
source('../src/data/db.R')

shinyServer(function(input, output) {
  
  # Note this is executed on page load and every time the submit button is clicked.
  output$output.plots <- renderUI({
    
    renderWebGL({
      
    })
        
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
  visualization.index <- as.integer(visualization)
  if (visualization.index > 1) {
    visualization.to.execute <- visualization.list[[visualization.index]]
    visualization.to.execute()
  }
}
