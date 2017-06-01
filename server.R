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
library(stringr)
library(rjson)

#scripts
source('scripts/setup.R')
source('scripts/BuildBarChart.R')
source('scripts/BuildLineChart.R')
source('scripts/analysis.R')
source('scripts/BuildRenderedChart.R')

# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data for API calls
geo_data <- read.csv("geo_data.csv")

## Twitter authentification credentials 
appname <- "twitter-weather-moscow-mules"

# Retrieving authentication credentials from .json 
twitter.key <- fromJSON(file = 'access-keys.json')$twitter$consumer_key
twitter.secret <- fromJSON(file = 'access-keys.json')$twitter$consumer_secret

# create token for authentication
twitter.token <- create_token(
  app = appname,
  consumer_key = twitter.key,
  consumer_secret = twitter.secret)

# call buildtimeline.R
shinyServer(function(input, output) {
  
  selectPlot <- reactive({
  #Tweets = bar chart
    
      plot.1 <- BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title", '13B0E9')
      plot.2 <- BuildLinePlot(mtcars, 'hp', 'drat', "hp", "drat", "else", 'FDE600')
      return(BuildLinePlot(mtcars, 'hp', 'drat', "hp", "drat", paste(input$chart, " hey"), 'FDE600'))
      #return(RenderPlots(plot.1, mtcars, "mpg", plot.2, mtcars, paste(input$chart)))
    
})
  
  output$fooPlot1 <- renderPlotly({
      print(selectPlot())
  })
  
  output$value <- renderPrint({input$start.date})
  output$value <- renderPrint({input$end.date})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
  output$value <- renderPrint({input$chart})
  output$about <- renderText({about})
  output$insights <- renderText({insights})
})
