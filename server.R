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


#scripts
source('scripts/setup.R') 

# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data for API calls
geo_data <- read.csv("geo_data.csv")

## Twitter authentification credentials 
appname <- "twitter-weather-moscow-mules"

# Retrieving authentication credentials from .json 
twitter.key <- fromJSON(txt = 'access-keys.json')$twitter$consumer_key
twitter.secret <- fromJSON(txt = 'access-keys.json')$twitter$consumer_secret

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
    twitter.data <- twitterData(location[,1], location[,2], input$dates)
    return(BuildBarPlot(twitter.data, twitter.data[,time], twitter.data[,freq], "Time", "Tweets", paste("Number of Tweets on", input$dates, "in", input$city)))
  
    } else if (input$chart == "Weather") {
  #Weather = line chart
      location <- str_split_fixed(input$city, ", ", 2)
      weather.data <- weatherData(location[,1], location[,2], input$dates)
      return(BuildLineChart(weather.data, weather.data[,time], weather.data[,temperature], "Time", "Weather", paste("Weather on", input$dates, "in", input$city)))
 
    } else {
    #both = both
      return(BuildRenderedChart(plot.1, data.1, y.var.1, plot.2, data.2, y.var.2))
  }
  })
  
  output$fooPlot1 <- renderPlotly({
      print(selectPlot())
    })
  
  output$value <- renderPrint({input$dates})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
  output$value <- renderPrint({input$chart})
})
