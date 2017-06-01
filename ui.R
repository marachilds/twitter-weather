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
      
      # Returns YYYY-MM-DD
      dateInput("start.date", "Select Start Date", min = min.start, max = max.start, value = max.start),
      
      # Returns YYYY-MM-DD
      dateInput("end.date", "Select End Date", min = min.end, max = max.end, value = max.end),
      
      # Returns Capital City, State
      selectInput("city", "Select City", choices = cities),
      
      # Returns Tweets or Weather
      checkboxGroupInput("chart", "Select Graphs", choices = c("Tweets", "Weather"), selected = "Tweets")
      
    ),
    
    # Plot it!
    mainPanel(
      
      tabsetPanel(
        
        # Plot panel
        tabPanel("Plot", plotlyOutput('fooPlot1', height = "600px", width = "800px")),
        
        # Insights panel
        tabPanel("Insights", textOutput('insights')),
        
        # About panel
        tabPanel("About", textOutput('about'))
      )

      )
    )
  )
)