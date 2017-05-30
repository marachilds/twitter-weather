# buildtimeline.R (ESHA)
# For tweets: bar chart of tweets over time (answers: when do people tweet the most?)
# For weather: line graph of temperature (scale so it will sit on same graph as tweets)
# If both are checked, render them on top of one another
# Add correlation

library(plotly)
library(ggplot2)
library(dplyr)

source("BuildBarChart.R")

# The plot1 variable determines the y axis, therefore, choose the plot that
# has a higher y max

RenderPlots <- function(plot1, plot2) {
 subplot(plot1, plot2, shareX = TRUE) 
}
