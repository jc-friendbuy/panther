library(shiny)
library(modules)
source('src/analysis/basic.R')

# shinyServer(router$Route2)
shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    
    output$visualization <- renderPlot({
        
        data.to.plot <- SelectSimpleDrugSubset()
#         plot(data.to.plot$x, data.to.plot$y)
        do.call(data.to.plot$fun, data.to.plot$args)
        
#         x    <- faithful[, 2]  # Old Faithful Geyser data
#         bins <- seq(min(x), max(x), length.out = input$bins + 1)
#         
#         # draw the histogram with the specified number of bins
#         hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
})
