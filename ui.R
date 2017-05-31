# Read in libraries
library(shiny)
library(plotly)

# Read in source scripts
source('./scripts')

# Create Shiny UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Twitter and Weather"),
  
  # Sidebar with select inputs for date, time, and city
  sidebarLayout(
    
    sidebarPanel(
      
      # Returns YYYY-MM-DD
      dateInput("dates", "Select Date"),
      
      # Returns date values as 0-24
      sliderInput("time", "Select Time Range",
                  min = 0, max = 24, value = c(0, 24)),
      
      # Returns Capital City, State
      selectInput("city", "Select City", choices = cities),
      
      # Returns Tweets or Weather
      selectInput("chart", "Select Graphs", choices = c("Tweets", "Weather"))
      
    ),
    
    # Plot it!
    mainPanel(
      
      plotlyOutput('fooPlot1', height = "600px", width = "800px")

      )
    )
  )
)