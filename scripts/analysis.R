# Days since state's capital city has been over a certain temperature (count)

source("scripts/setup.R")
# analysis.R

# About section text
about <- "This is a project created by Mara Childs, Isabel Giang, Nikhila Iyer, and Esha More for Informatics 201 
          at the University of Washington. After living in the grey Seattle weather for so long, we were curious 
          about how the weather affects people’s tweeting habits. We wanted to know if and how the weather affects 
          the number of tweets.

          In this web application, we leveraged the Twitter Streaming API and the Dark Sky Weather API to chart 
          the capital cities’ temperatures over time and the number of geotagged tweets over time. We are only 
          able to grab the last 10,000 tweets (max) due to the Twitter API request runtime, and these are graphed 
          from the latest 10,000 rather than equally distributed throughout the date range. Findings are summarized 
          in the Insights tab.

          Questions? Reach out—michilds@uw.edu."

# variables
# city <- user.input
# highest.temp <- summarize(data, highest = max(temperature))
# lowest.temp <- summarize(data, lowest = min(temperature))
# num.tweets <- filter(data, data = input.date)
# 
# # Insights section text
# insights <- paste0("In this city of ", city, " The highest temperature reached was ",
#                    highest.temp, " degrees Farenheit. The lowest temperature reached was ",
#                    lowest.temp, " degrees Farenheit. At this time there were about",
#                    num.tweets, "tweets total.")
