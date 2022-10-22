################################################################################
# Entry point of the Shiny app
#
# Author: Dongli He
# Created: 9/10/2022 14:50
################################################################################

# Package names
# "tidyr", "dplyr", "ggplot2"
packages <- c("shiny", "shinyjs", "shinythemes", "shinydashboard", "plotly",
              "shinyWidgets", "shinycssloaders", "sf", "spData", "leaflet",
              "leaflet.extras", "leaflet.extras2", "tidyverse", "DT",
              "lubridate", "jsonlite", "stringi"
              )

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Load packages
invisible(lapply(packages, library, character.only = TRUE))
source("functions/utils.R")
cores <- c("#098ebb", "#fdc23a", "#e96449", "#818286")

# Turn off warning
# options(warn = -1)

## Load data
# Event data
DATA_FOLDER = "data"

event_data <- fromJSON(file.path(DATA_FOLDER, "item.json"))
event_data <- select(event_data, -c("img_urls", "thumb_url", "href"))
event_data$title <- paste("3", event_data$title, sep="")

# Eating and hotels
eatingout <- read.csv(file.path(DATA_FOLDER, "eatingout.csv"))
eatingout$name <- paste("1", eatingout$name, sep="")
hotels <- read.csv(file.path(DATA_FOLDER, "hotels.csv"))
hotels$name <- paste("2", hotels$name, sep="")

# Flight
dataTable <- read.table(file.path(DATA_FOLDER, "futureFlightData.csv"), header = TRUE, fill = TRUE, sep=",")
print(dataTable)
# Suburb
suburb <- st_read(file.path(DATA_FOLDER, "suburb.shp"))

# Icons
EventIcon <- makeIcon(file.path("data", "icons", "Events1.png"), iconWidth=40, iconHeight=40)
EatingIcon <- makeIcon(file.path("data", "icons", "Eatings1.png"), iconWidth=40, iconHeight=40)
HotelIcon <- makeIcon(file.path("data", "icons", "Hotels1.png"), iconWidth=40, iconHeight=40)

EventIconBig <- makeIcon(file.path("data", "icons", "Events1.png"), iconWidth=60, iconHeight=60)
EatingIconBig <- makeIcon(file.path("data", "icons", "Eatings1.png"), iconWidth=60, iconHeight=60)
HotelIconBig <- makeIcon(file.path("data", "icons", "Hotels1.png"), iconWidth=60, iconHeight=60)


#global var for eating filters
eatingTagsSelected <- c('breakfast', 'lunch', 'dinner', 'drinks', 'coffee', 'icecream')
eatingScoreSelected <- c(0, 1, 2, 3, 4)
eatingPriceSelected <- c("cheap", "medium", "expensive")

#global var for hotels filters
hotelsScoreSelected <- c(0, 1, 2, 3, 4)
hotelsPriceSelected <- c("cheap", "medium", "expensive")