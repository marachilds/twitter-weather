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
# test2 <- twitterData("Portland", "ME", "2017-05-25", "2017-05-26")

# call buildtimeline.R
shinyServer(function(input, output) {
  
  selectPlot <- reactive({
  #Tweets = bar chart
    location <- str_split(input$city, ", ")
    print(location)
    state <- state.abb[grep(location[[1]][2], state.name)]
    print(state)
    
    if (input$radio == 1) {
      twitter.data <- twitterData(location[[1]][1], state, "2017-05-25", "2017-05-26")
      return(BuildBarPlot(twitter.data, "hour", "count",
                           "Time", "Tweets", paste("Tweets on", input$dates, "in", input$city)))
    } else if (input$radio == 2) {
    #Weather = line chart
      weather.data <- weatherData(location[[1]][1], state, "29 May 2017")
      return(BuildLinePlot(weather.data, "time", "temperature",
                           "Time", "Weather", paste("Weather on", input$dates, "in", input$city)))
      #return(BuildLineChart(weather.data, 'time', "temperature", "Time", "Weather",
          #paste("Weather on", input$dates, "in", input$city), 'FDE600'))
    } else {
      plot.1 <- BuildLinePlot(twitter.data, "hourly.range", "freq",
                              "Time", "Tweets", paste("Tweets on", input$dates, "in", input$city))
      plot.2 <- BuildLinePlot(weather.data, "time", "temperature",
                              "Time", "Weather", paste("Weather on", input$dates, "in", input$city))
      return(BuildRenderPlots(plot.1, weather.data, "temperature", plot.2, twitter.data, "freq",
                              "Temperature", "Tweets", "Comparison of temperature and tweets"))
    }
})
  
  output$fooPlot1 <- renderPlotly({
    return(selectPlot())
    # dataInput <- reactive({
    #   getSymbols(input$city, src = ",", 
    #              from = input$dates[1],
    #              to = input$dates[2],
    #              auto.assign = FALSE)
    # })
    # weather.data <- weatherData(substring(input$city, 0, pos), substring(input$city, pos), input$dates)
  })
  
  output$value <- renderPrint({input$start.date})
  output$value <- renderPrint({input$end.date})
  output$value <- renderPrint({input$time})
  output$value <- renderPrint({input$city})
  output$value <- renderPrint({input$chart})
  output$about <- renderText({about})
  output$insights <- renderText({insights})
})
