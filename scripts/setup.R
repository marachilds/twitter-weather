library(streamR)
library(rgeos)
library(rgdal)
library(httr)
library(dplyr)

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

# dataset to find latitude and longitude of cities for API call
geo_data <- findGeoData()

twitterData <- function() {
  
}

weatherData <- function() {
  base.url <- "https://api.darksky.net/forecast/"
  district.uri <- paste0(base.url, district.resource)
  district.query.params <- list(zip = zip.code)
  
  # retrieving data
  district.response <- GET(district.uri, query = district.query.params)
  district.body <- content(district.response, "text")
  district.results <- as.data.frame(fromJSON(district.body))
}

# code for findLatLong and findGeoData sourced from: 
# https://stackoverflow.com/posts/27868207/revisions


# Returns a data frame that contains the longitude and latitude
# for the given state and city.
# Ex: lon       lat       city      state
#     -70.25404 43.66186  Portland   ME
findLatLong <- function(geog_data, city, state) {
  do.call(rbind.data.frame, mapply(function(x, y) {
    geog_data %>% filter (city == x, state == y)
  }, city, state, SIMPLIFY = FALSE))
}


# Retrieves dataset for towns and cities in Canada/US with latitudinal and 
# longitudinal data
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