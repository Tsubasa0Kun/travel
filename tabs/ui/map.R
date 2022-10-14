################################################################################
# UI of the map page
#
# Author: Dongli He
# Created: 13/10/2022 17:15
################################################################################

tab_files <- list.files(path = "tabs/ui/map", full.names = T)
suppressMessages(lapply(tab_files, source))

map_container <- tabPanel(title = "Map", 
                      value = "map_container",
                      hr(),
                      tabsetPanel(
                        map
                      )
)

