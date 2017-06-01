library(rtweet)
library(jsonlite)
library(rgeos)
library(rgdal)
library(httr)
library(dplyr)
library(anytime)

# Test Variables (delete before launch!)
# --------------------------------------
start_date <- "2017-05-28"
end_date <- "2017-05-29"
city <- "Portland"
state <- "ME"
day <- "2017-05-28"


# Latitude & Longitude Retrieval for API Calls
# --------------------------------------------
# Code for findLatLong and findGeoData sourced from: 
# https://stackoverflow.com/posts/27868207/revisions

# Returns a data frame that contains the longitude and latitude
# for the given state and city.
# Input format: findLatLong(geog_db, "Portland", "ME")
# Ex: lon       lat       city      state
#     -70.25404 43.66186  Portland   ME
findLatLong <- function(geo_db, city, state) {
  do.call(rbind.data.frame, mapply(function(x, y) {
    geo_db %>% filter(city==x, state==y)
  }, city, state, SIMPLIFY=FALSE))
}


# Global Variables (Mara)
# ----------------

# Options list for states and capital cities
cities <- c("Montgomery, Alabama", "Juneau, Alaska", "Phoenix, Arizona",
            "Little Rock, Arkansas", "Sacramento, California", "Denver, Colorado",
            "Hartford, Connecticut", "Dover, Delaware", "Tallahassee, Florida",
            "Atlanta, Georgia", "Honolulu, Hawaii", "Boise, Idaho", "Springfield, Illinois",
            "Indianapolis, Indiana", "Des Moines, Iowa", "Topeka, Kansas", "Frankfort, Kentucky", 
            "Baton Rouge, Louisiana", "Augusta, Maine", "Annapolis, Maryland", "Boston, Massachusetts", 
            "Lansing, Michigan", "St. Paul, Minnesota", "Jackson, Mississippi", "Jefferson City, Missouri",
            "Helena, Montana", "Lincoln, Nebraska", "Carson City, Nevada", "Concord, New Hampshire",
            "Trenton, New Jersey", "Santa Fe, New Mexico", "Albany, New York", "Raleigh, North Carolina",
            "Bismarck, North Dakota", "Columbus, Ohio", "Oklahoma City, Oklahoma", "Salem, Oregon",  
            "Harrisburg, Pennsylvania", "Providence, Rhode Island", "Columbia, South Carolina",
            "Pierre, South Dakota", "Nashville, Tennessee", "Austin, Texas", "Salt Lake City, Utah",
            "Montpelier, Vermont", "Richmond, Virginia", "Olympia, Washington", "Charleston, West Virginia",
            "Madison, Wisconsin", "Cheyenne, Wyoming"
            )

# Setting minimum start date
min.start <- Sys.Date()-6

# Setting maximum start date
max.start <- Sys.Date()-1

# Setting minimum end date
min.end <- Sys.Date()-5

# Setting maximum end date
max.end <- Sys.Date()

# API Calls - Data Retrieval
# -------------------------
# Retrieves a data frame with the most recent 10000 tweets for a given state and city that were 
# tweeted between the given start date and end date.
# Ex: hourly.range          Freq
#     2017-05-28 14:00:00   141
twitterData <- function(city, state, start_date, end_date) {
  # Retrieves latitude and longitude for the given state and city for API query
  lat.long.df <- geo_data %>% findLatLong(city, state)
  longitude <- lat.long.df[,1]
  latitude <- lat.long.df[,2]
  
  # Gets 10000 tweets and other information from specified location from the given time range.
  twitter.df <- search_tweets(q = " ", geocode = paste0(latitude, ",", longitude, ",","20mi"), n = 10000, 
                              since = start_date, until = end_date, usr = "false")
  # Filters dataset to only the column containing the time stamps.
  twitter.df.times <- twitter.df %>% select(created_at)
  # Generates an hourly range (all of the hours that the tweets occur in) to sort the data by
  hourly.range <- cut(twitter.df$created_at, breaks="hour")
  # Creates data frame with the number of tweets (Freq) that occur in each hour.
  twitter.result <- data.frame(table(hourly.range))
  return (twitter.result)
}

# Retrieves a data frame with weather data for the specified day with the given city and state,
# with hourly time block starting from midnight of the day requested, 
# continuing until midnight of the following day. Hourly time blocks start from the current system time.
# input format: weatherData("Portland", "ME", "28 May 2017"), multiple Date formats should work
# Ex: temperature     time
#     45.3690         2017-05-27 14:00:00
weatherData <- function(city, state, day) {
  
  # Retrieve latitude and longitude for given city and state
  lat.long.df <- geo_data %>% findLatLong(city, state)
  longitude <- lat.long.df[,1]
  latitude <- lat.long.df[,2]
  
  # Convert given Date to UNIX format
  unix.time.day <- as.numeric(as.POSIXct(anydate(day)))
  
  # Retrieve API key from key.JSON (stored in JSON for security)
  key <- fromJSON(file = "access-keys.json")$weather$key

  # setting params for API  call
  base.url <- "https://api.darksky.net/forecast/"
  weather.uri <- paste0(base.url, key, "/", longitude, ",", latitude, ",", unix.time.day)
  weather.params <- list(exclude = paste0("currently", ",", "minutely", ",", "flags"))

  # retrieving data from API
  weather.response <- GET(weather.uri, query = weather.params)
  weather.body <- content(weather.response, "text")
  weather.results <- fromJSON(weather.body)
  
  # Gets data sorted by hour
  weather.df <- weather.results$hourly$data
  
  # convert UNIX time to Dates
  weather.df$time <- anytime(weather.df$time)
  
  # convert Celsius temperatures to Fahrenheit
  weather.df$temperature <- weather.df$temperature * (9/5) + 32
  
  weather.df <- weather.df %>% select(temperature, time)
  weather.df[,temperature]
  return(weather.df) 
}


