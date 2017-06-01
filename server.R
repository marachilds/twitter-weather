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
    if (input$chart == "Tweets") {
      location <- str_split_fixed(input$city, ", ", 2)
      #twitter.data <- twitterData(location[,1], location[,2], input$start.date, input$end.date)
      return(BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title"))
      #return(BuildBarPlot(twitter.data, twitter.data[,time], twitter.data[,freq], "Time", "Tweets", paste("Number of Tweets on", input$dates, "in", input$city)))
  
    } else if (input$chart == "Weather") {
    #Weather = line chart
      location <- str_split_fixed(input$city, ", ", 2)
      #weather.data <- weatherData(location[,1], location[,2], input$start.date)
      return(BuildLinePlot(mtcars, 'hp', 'drat', "hp", "drat", "else"))
      #return(BuildLineChart(weather.data, 'time', "temperature", "Time", "Weather", paste("Weather on", input$dates, "in", input$city)))
    } else {
      #both
    }
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
