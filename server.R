# server.R

#libraries
library(shiny)
library(dplyr)
library(plotly)

#scripts
source('./scripts/setup.R')

#call buildtimeline.R
shinyServer(function(input, output) {
  output$mainPlot <- renderPlot() #Esha's graphs called here
  
  output$value <- renderPrint({input$dates})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
})