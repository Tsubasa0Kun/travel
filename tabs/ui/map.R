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

                    absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                  draggable = TRUE, top = 260, left = 20, right = "auto", bottom = "auto",
                                  width = 330, height = "auto", 

                                  # selectInput("color", "Color", vars),
                                  # selectInput("size", "Size", vars, selected = "adultpop"),
                                  # conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                  #                  # Only prompt for threshold when coloring or sizing by superzip
                                  #                  numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                  # ),
                                  #
                                  uiOutput("contents"),
                    ),
)
                    