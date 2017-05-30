library(streamR)
library(jsonlite)
library(rgeos)
library(rgdal)
library(httr)
library(dplyr)

# Global Variables 
# ----------------

# Options list for states and capital cities (Mara)
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

# Dataset to find latitude and longitude of cities for API call
geo_data <- findGeoData()


# API Calls - Data Retrieval
# -------------------------
# TO-DO: Weather API - get results by specific time - find out what the time input will be (by year, month, day?)
# TO-DO: Twitter API - get number of tweets by location, number of tweets by time



# Retrieves a data frame with the number of tweets for a given state, city and day,
# with tweets by hour.
twitterData <- function(city, state, day) {
  lat.long.df <- geo_data %>% findLatLong(city, state)
  curr.long <- lat.long.df[,1]
  curr.lat <- lat.long.df[,2]
}

# Retrieves a data frame with weather data for the specified day with the given city and state,
# with hourly time block starting from midnight of the day requested, 
# continuing until midnight of the following day.
weatherData <- function(city, state, day) {
  # Retrieve latitude and longitude for given city and state
  lat.long.df <- geo_data %>% findLatLong(city, state)
  curr.long <- lat.long.df[,1]
  curr.lat <- lat.long.df[,2]
  
  # Retrieve API key from key.JSON (stored in JSON for security)
  key <- "f2816b4bb0266a96e77991a187b35d9c"
  # key <- Sys.getenv("WEATHER_KEY"), not working for some reason
  

  base.url <- "https://api.darksky.net/forecast/"
  weather.uri <- paste0(base.url, key, "/", curr.long, ",", curr.lat)

  # retrieving data
  weather.response <- GET(weather.uri)
  weather.body <- content(weather.response, "text")
  weather.results <- as.data.frame(fromJSON(weather.body))
}


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


# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data
findGeoData <- function() {
  try({
    GET("http://www.mapcruzin.com/fcc-wireless-shapefiles/cities-towns.zip",
      write_disk("cities.zip"))
    unzip("cities.zip", exdir="cities") })
  
  # reads in shape file from URL
  shp <- readOGR("cities/citiesx020.shp", "citiesx020")
  
  # extract city centroids from shape file with name and state
  geo.data <- 
    gCentroid(shp, byid = TRUE) %>%
    data.frame() %>%
    rename(lon = x, lat = y) %>%
    mutate(city = shp@data$NAME, state = shp@data$STATE)
  
  return(geo.data)
}