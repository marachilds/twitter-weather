# buildtimeline.R (ESHA)
# For tweets: bar chart of tweets over time (answers: when do people tweet the most?)
# For weather: line graph of temperature (scale so it will sit on same graph as tweets)
# If both are checked, render them on top of one another
# Add correlation

library(plotly)
library(ggplot2)
library(dplyr)

# The plot1 variable determines the y axis, therefore, choose the plot that
# has a higher y max

BuildRenderPlots <- function(plot.1, data.1, y.var.1, plot.2, data.2, y.var.2) {
 plot.3 <- plot_ly(data = data.1,
                   x = data.1[[y.var.1]],
                   y = data.2[[y.var.2]],
                   type = "scatter",
                   marker = list(size = 20,
                                 line = list(color = 'rgba(0, 0, 0, .8)',
                                             width = 2),
                                 opacity = 0.7))
  return(subplot(plot.1, plot.2, plot.3, shareX = TRUE))
}

plot1 <- BuildBarPlot(mtcars, 'mpg', 'cyl', "1", "2", "title")
plot2 <- BuildLinePlot(mtcars, 'hp', 'drat', "hp", "drat", "else")

BuildRenderPlots(plot.1 =  plot1, data.1 =  mtcars, y.var.1 =  "mpg", plot.2 =  plot2, data.2 =  mtcars, y.var.2 =  "hp")
