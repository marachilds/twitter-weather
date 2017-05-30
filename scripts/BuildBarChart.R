# buildtimeline.R (ESHA)
# For tweets: bar chart of tweets over time (answers: when do people tweet the most?)
# For weather: line graph of temperature (scale so it will sit on same graph as tweets)
# If both are checked, render them on top of one another
# Add correlation

library(plotly)
library(ggplot2)
library(dplyr)

BuildBarPlot <- function(data, x.var, y.var, x.label, y.label, title, color.var) {
  p <- plot_ly(data = data,
    x = data[[x.var]],
    y = data[[y.var]],
    type = "bar",
    color = data[[color.var]]
  ) %>%
    layout(
      title = title,
      xaxis = list(title = x.label),
      yaxis = list(title = y.label),
      barmode = "group"
    )
  p <- hide_colorbar(p)
    # layout(
    #   yaxis = list(range = c(0, 100))
    # )
  return(p)
}