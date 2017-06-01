# Read in libraries
library(shiny)
library(plotly)

# Read in source scripts
source('scripts/setup.R')

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
      
      # Returns 1 (Tweets) or 2 (Weather) or 3 (Both)
      radioButtons("radio", label = "Charts to Display",
                   choices = list("Tweets" = 1, "Weather" = 2, "Both" = 3), 
                   selected = 2)),
    
    # Plot it!
    mainPanel(
      
      tabsetPanel(
        
        # Plot panel
        tabPanel("Plot", plotlyOutput('fooPlot1', height = "600px", width = "800px")),
        
        tabPanel("About", textOutput('about'))
        # ,
        # 
        # # Insights panel
        # tabPanel("Insights", textOutput('insights')),
        # 
        # # About panel
        # tabPanel("About", textOutput('about'))
      )

      )
    )
  )
)