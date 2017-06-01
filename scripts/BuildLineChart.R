# buildtimeline.R (ESHA)
# For tweets: bar chart of tweets over time (answers: when do people tweet the most?)
# For weather: line graph of temperature (scale so it will sit on same graph as tweets)
# If both are checked, render them on top of one another
# Add correlation

library(plotly)
library(ggplot2)
library(dplyr)

BuildLinePlot <- function(data, x.var, y.var, x.label, y.label, title, color.var){
  p <- plot_ly(data = data,
               x = data[[x.var]],
               y = data[[y.var]],
               type = "scatter",
               marker = list(size = 20,
                             color = data[[color.var]],
                             line = list(color = 'rgba(0, 0, 0, .8)',
                                         width = 2),
                             opacity = 0.7)) %>%
    layout(title = title,
           yaxis = list(title = x.label),
           xaxis = list(title = y.label))
  return(p)
}
