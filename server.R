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
    if (input$radio == 1) {
      location <- str_split_fixed(input$city, ", ", 2)
      #twitter.data <- twitterData(location[,1], location[,2], input$start.date, input$end.date)
      return(BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title"))
      #return(BuildBarPlot(twitter.data, twitter.data[,time], twitter.data[,freq], "Time", "Tweets", 
              #paste("Number of Tweets on", input$dates, "in", input$city), '13B0E9'))
  
    } else if (input$radio == 2) {
    #Weather = line chart
      location <- str_split_fixed(input$city, ", ", 2)
      #weather.data <- weatherData(location[,1], location[,2], input$start.date)
      return(BuildLinePlot(mtcars, 'hp', 'drat', "hp", "drat", "else"))
      #return(BuildLineChart(weather.data, 'time', "temperature", "Time", "Weather",
          #paste("Weather on", input$dates, "in", input$city), 'FDE600'))
    } else if (input$radio == 3) {
      plot.1 <- BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title")
      plot.2 <- BuildLinePlot(mtcars, 'hp', 'cyl', "hp", "cyl", "else")
      return(BuildRenderPlots(plot.1, mtcars, "mpg", plot.2, mtcars, "hp"))
    }
})
  
  output$fooPlot1 <- renderPlotly({
    print(selectPlot())
    location <- str_split_fixed(input$city, ", ", 2)
    weather.data <- weatherData(location[,1], location[,2], input$dates)

    return(BuildLineChart(weather.data, weather.data[weather.data$time], weather.data[weather.data$temperature], "Time", "Weather", paste("Weather on", input$dates, "in", input$city)))
  })
  
  output$value <- renderPrint({input$start.date})
  output$value <- renderPrint({input$end.date})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
  output$value <- renderPrint({input$chart})
  output$about <- renderText({about})
  output$insights <- renderText({insights})
})
