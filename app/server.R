library(shiny)
library(shinyRGL)
library(rgl)
library(MASS)
source('visualization_config.R')

# shinyServer(function(input, output) {
#     # Compute the results of the requested visualization and determine
#     # the appropriate render function so it can be displayed on the UI
#     output$visualization <- renderPlot({
#         computed.visualization <- ExecuteVisualization(
#           input$visualization.select
#         )
# 
#         do.call(
#           computed.visualization$graphing.function.name,
#           computed.visualization$args
#         )
#     })
# 
#     output$vis3d <- renderWebGL({
#       # parameters:
#       n <- 250
#       ngrid<-40
# 
#       # generate samples:
#       set.seed(31415)
#       x<-rnorm(n); y<-rnorm(n)
# 
#       # estimate non-parameteric density surface via kernel smoothing
#       denobj<-kde2d(x, y, n = ngrid)
#       den.z <-denobj$z
# 
#       # generate parametric density surface of a bivariate normal distribution
#       xgrid <- denobj$x
#       ygrid <- denobj$y
#       bi.z <- dnorm(xgrid)%*%t(dnorm(ygrid))
# 
#       # visualize:
#       zscale<-20
# 
#       # setup env:
#       light3d()
# 
#       # Draws the simulated data as spheres on the baseline
#       spheres3d(x,y,rep(0,n),radius=0.1,color="#333399")
# 
#       # Draws non-parametric density
#       surface3d(xgrid,ygrid,den.z*zscale,color="#FF2222",alpha=0.5)
# 
#       # Draws parametric density
#       surface3d(xgrid,ygrid,bi.z*zscale,color="#2222FF",front="lines")
#     })
# })

shinyServer(function(input, output) {
  
  output$output.plots <- renderUI({
    
    computed.visualizations <- ExecuteVisualization(
      input$visualization.select
    )
    
    # Go through all the returned computed visualizations to generate the outputs
    # where the graphs will be rendered
    current.id <- 0
    output.list <- lapply(computed.visualizations, function(visualization) {
      current.id <- current.id + 1
      output.function <- SelectOutputFunction(visualization$graph.type)
      visualization.id <- paste0('visualization', current.id)
      output.function(visualization.id)
    })
    do.call(tagList, output.list)
    
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

SelectOutputFunction <- function(visualization.function) {
  switch(visualization.function,
         plot = plotOutput,
         hist = plotOutput,
         plot3d = webGLOutput
  )
}

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
