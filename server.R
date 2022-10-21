################################################################################
# Server of the Shiny app
#
# Author: Dongli He
# Created: 9/10/2022 14:50
################################################################################

# Define server logic
shinyServer(function(input, output, session){
  ##-- HOME ----
  source("tabs/server/home.R", local = TRUE)
  ##-- FLIGHT ----
  source("tabs/server/flight.R", local = TRUE)
  ##-- MAP ----
  source("tabs/server/map.R", local = TRUE)
  ##-- ABOUT ----
  source("tabs/server/about.R", local = TRUE)
})
