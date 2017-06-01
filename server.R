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
<<<<<<< HEAD
    #Tweets = bar chart
=======
  #Tweets = bar chart
<<<<<<< HEAD
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
=======
>>>>>>> 31e40015e2f56536137f34bb192cc0158aedde32
    if (input$radio == 1) {
      location <- str_split_fixed(input$city, ", ", 2)
      #twitter.data <- twitterData(location[,1], location[,2], input$start.date, input$end.date)
      return(BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title"))
      #return(BuildBarPlot(twitter.data, twitter.data[,time], twitter.data[,freq], "Time", "Tweets", 
<<<<<<< HEAD
      #paste("Number of Tweets on", input$dates, "in", input$city), '13B0E9'))
      
    } else if (input$radio == 2) {
      #Weather = line chart
=======
              #paste("Number of Tweets on", input$dates, "in", input$city), '13B0E9'))
  
    } else if (input$radio == 2) {
    #Weather = line chart
>>>>>>> 31e40015e2f56536137f34bb192cc0158aedde32
      location <- str_split_fixed(input$city, ", ", 2)
      #weather.data <- weatherData(location[,1], location[,2], input$start.date)
      return(BuildLinePlot(mtcars, 'hp', 'cyl', "3", "2", "else"))
>>>>>>> 0902823fad66de1aa0e8d6c9fef986478a8ee823
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
<<<<<<< HEAD
    return(selectPlot())
    # dataInput <- reactive({
    #   getSymbols(input$city, src = ",", 
    #              from = input$dates[1],
    #              to = input$dates[2],
    #              auto.assign = FALSE)
    # })
=======
    renderPrint(selectPlot())
    location <- strsplit(input$city, ", ")
    weather.data <- weatherData(location[[1]][1], location[[1]][2], input$dates)
    
    #return(BuildLinePlot(weather.data, "time", "temperature"))
    pos <- regexpr(input$city, ",")
>>>>>>> 0902823fad66de1aa0e8d6c9fef986478a8ee823
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