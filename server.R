# server.R

#libraries
library(anytime)
library(shiny)
library(dplyr)
library(plotly)
library(httr)
library(rgeos)
library(jsonlite)
library(rgdal)
library(rtweet)


#scripts
#setwd('~/Documents/College/Sophomore (2016-2017)/Spring Quarter/INFO201/twitter-weather')
source('scripts/BuildBarChart.R', chdir = T) 

# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data for API calls
geo_data <- read.csv("geo_data.csv")

## Twitter authentification credentials 
appname <- "twitter-weather-moscow-mules"

# Retrieving authentication credentials from .json 
twitter.key <- fromJSON(txt='access-keys.json')$twitter$consumer_key
twitter.secret <- fromJSON(txt='access-keys.json')$twitter$consumer_secret

# create token for authentication
twitter.token <- create_token(
  app = appname,
  consumer_key = twitter.key,
  consumer_secret = twitter.secret)

# call buildtimeline.R
shinyServer(function(input, output) {

  #output$mainPlot <- BuildLinePlot(data, x.var, y.var, x.label, y.label, title)
  #output$mainPlot <- RenderPlots(plot.1, y.var.1, plot.2, y.var.2)
  
  #Tweets = bar chart
  output$fooPlot1 <- renderPlotly({
    return(BuildBarPlot(dataset, twi, 'drat', "Time", "Tweets", paste("Number of Tweets on", input$dates, "in", input$city)))
  })
  
  #Weather = line chart
  output$fooPlot1 <- renderPlotly({
    return(BuildLineChart(dataset, twi, 'drat', "Time", "Weather", paste("Weather on", input$dates, "in", input$city)))
  })
  
  #both = both
  output$fooPlot1 <- renderPlotly({
    return(BuildRenderedChart(plot.1, data.1, y.var.1, plot.2, data.2, y.var.2))
  })
  
  output$value <- renderPrint({input$dates})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
  output$value <- renderPrint({input$chart})
})