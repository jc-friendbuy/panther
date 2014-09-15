library(shiny)
library(shinyRGL)
library(rgl)
library(MASS)
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

    output$vis3d <- renderWebGL({
      # parameters:
      n <- 250
      ngrid<-40

      # generate samples:
      set.seed(31415)
      x<-rnorm(n); y<-rnorm(n)

      # estimate non-parameteric density surface via kernel smoothing
      denobj<-kde2d(x, y, n=ngrid)
      den.z <-denobj$z

      # generate parametric density surface of a bivariate normal distribution
      xgrid <- denobj$x
      ygrid <- denobj$y
      bi.z <- dnorm(xgrid)%*%t(dnorm(ygrid))

      # visualize:
      zscale<-20

      # setup env:
      light3d()

      # Draws the simulated data as spheres on the baseline
      spheres3d(x,y,rep(0,n),radius=0.1,color="#333399")

      # Draws non-parametric density
      surface3d(xgrid,ygrid,den.z*zscale,color="#FF2222",alpha=0.5)

      # Draws parametric density
      surface3d(xgrid,ygrid,bi.z*zscale,color="#2222FF",front="lines")
    })
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
