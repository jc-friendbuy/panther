library(shiny)
source('visualization_config.R')

shinyServer(function(input, output) {
    # Compute the results of the requested visualization and determine
    # the appropriate render function so it can be displayed on the UI
    output$visualization <- renderPlot({
        computed.visualization <- ExecuteVisualization(
          input$visualization.select
        )
        
        do.call(
          computed.visualization$graphing.function.name,
          computed.visualization$args
        )
    })

    # output$visualization <- renderPlot({
    #
    #     computed.visualization <- ExecuteVisualization(
    #       input$visualization.select
    #     )
    #
    #     do.call(
    #       computed.visualization$graphing.function.name,
    #       computed.visualization$args
    #     )
    # })
})

SelectRenderingFunction <- function(visualization.function) {
  switch(visualization.function,
    plot = renderPlot
  )
}

ExecuteVisualization <- function(visualization) {
  visualization.to.execute <- visualization.list[[as.integer(visualization)]]
  visualization.to.execute()
}
