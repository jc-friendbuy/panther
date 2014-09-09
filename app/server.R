library(shiny)
source('src/analysis/basic.R')

shinyServer(function(input, output) {
    # Determine the appropriate render function for the selected visualization, and     
    # query / calculate the results.  Then, return it so it can be displayed on the UI.
    output$visualization <- renderPlot({
        data.to.plot <- SelectSimpleDrugSubset()
        do.call(data.to.plot$fun, data.to.plot$args)
    })
})
