################################################################################
# UI of the map page
#
# Author: Dongli He, Louhao Fang
# Created: 13/10/2022 17:15
################################################################################

map_container <- tabPanel(title = "Map", 
                    value = "map_container",
                    hr(),
                    fluidRow(
                      column(3, align="center",
                             checkboxInput(inputId = "eatingout", label = "Eating Out", value = TRUE),
                             actionButton("filterForEatingout", "filter")
                      ),
                      
                      column(3, align="center",
                             checkboxInput(inputId = "hotels", label = "Hotels", value = TRUE),
                             actionButton("filterForHotels", "filter")
                      ),
                      column(3, align="center",
                             checkboxInput(inputId = "events", label = "Events", value = TRUE),
                             actionButton("filterForEvents", "filter")
                      ),
                      column(3, align="center",
                             checkboxInput(inputId = "attractions", label = "Attractions", value = TRUE),
                             actionButton("filterForAttractions", "filter")
                      ),
                    ),
                    hr(),
                  div(class="outer",
                      tags$style(HTML(
                        "div.outer {
                        position: fixed;
                        top: 259px;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        overflow: hidden;
                        padding: 0;
                        }")),
                      leafletOutput("mymap", width="100%", height="100%")),

                    absolutePanel(
                      id = "popup_panel", class = "panel panel-default",
                      fixed = FALSE, draggable = TRUE, top = 260, left = "auto",
                      right = "0", bottom = "auto", width = 330,
                      height = "auto", style = "overflow-y: auto;",
                      uiOutput("contents"),
                    ),
)
                    
