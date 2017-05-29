# server.R

#libraries
library(shiny)
library(dplyr)
library(plotly)

#scripts



#call buildtimeline.R
shinyServer(function(input, output) {
  output$mainPlot <- renderPlot()
  
  output$value <- renderPrint({input$dates})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
})