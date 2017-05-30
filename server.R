# server.R

#libraries
library(shiny)
library(dplyr)
library(plotly)
library(streamR)
library(httr)
library(rgeos)
library(jsonlite)
library(rgdal)


#scripts
#setwd('~/Documents/College/Sophomore (2016-2017)/Spring Quarter/INFO201/twitter-weather')
source('scripts/BuildRenderedChart.R')

#call buildtimeline.R
shinyServer(function(input, output) {
  #output$mainPlot <- BuildBarPlot(twitter.data, input$time, y.var, 'Time', 'Number of Tweets', 'Number of Tweets Throughout the Day')
  #output$mainPlot <- BuildLinePlot(data, x.var, y.var, x.label, y.label, title)
  #output$mainPlot <- RenderPlots(plot.1, y.var.1, plot.2, y.var.2)
  
  output$mainPlot <- BuildBarPlot(mtcars, 'hp', 'drat', "MPG", "CYL", "mpg v cyl")
  
  # output$value <- renderPrint({input$dates})
  # output$value <- renderPrint({input$time})
  # output$value <- renderPrint({input$city})
})