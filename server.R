# server.R

# libraries
## Dependencies for setup.R
library(dplyr)
library(anytime)
library(jsonlite)
library(rgeos)
library(rgdal)
library(rtweet) 

library(shiny)
library(plotly)
library(httr)
library(stringr)

#scripts

source('scripts/setup.R')
source('scripts/BuildBarChart.R')
source('scripts/BuildLineChart.R')
source('scripts/analysis.R')
source('scripts/BuildRenderedChart.R')


test <- weatherData("Portland", "ME", "28 May 2017")
# twitterData(city, state, start_date, end_date)
test2 <- twitterData("Portland", "ME", "2017-05-25", "2017-05-26")

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
