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
              "leaflet.extras2", "tidyverse", "DT", "lubridate", "jsonlite"
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

# turn off warning
# options(warn = -1)

# Load data
DATA_FOLDER = "data"

event_data = fromJSON(file.path(DATA_FOLDER, "item.json"))
event_data = select(event_data, -c("img_urls", "thumb_url", "href"))

suburb = st_read(file.path(DATA_FOLDER, "suburb.shp"))
