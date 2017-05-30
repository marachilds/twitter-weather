# Read in libraries
library(shiny)
library(plotly)

# Read in source scripts
source('./scripts/setup.R')

# Create Shiny UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Twitter and Weather"),
  
  # Sidebar with select inputs for date, time, and city
  sidebarLayout(
    
    sidebarPanel(
      
      dateInput("dates", "Select Date"),
      sliderInput("time", "Select Time Range",
                  min = 0, max = 24, value = c(0, 24)),
      selectInput("city", "Select City", choices = cities)
      
    ),
    
    # Plot it!
    mainPanel(
      plotlyOutput('mainPlot', height = "600px", width = "800px")
      )
    )
  )
)