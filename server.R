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
source('~/Documents/College/Sophomore (2016-2017)/Spring Quarter/INFO201/twitter-weather/scripts/setup.R')

#call buildtimeline.R
shinyServer(function(input, output) {
  output$mainPlot <- BuildBarPlot(twitter.data, input$time, y.var, 'Time', 'Number of Tweets', 'Number of Tweets Throughout the Day', color)
  
  output$value <- renderPrint({input$dates})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
})