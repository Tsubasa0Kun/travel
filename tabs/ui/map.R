################################################################################
# UI of the map page
#
# Author: Dongli He
# Created: 13/10/2022 17:15
################################################################################

map_container <- tabPanel(title = "Map", 
                    value = "map_container",
                    hr(),
                    # includeCSS("www/plugins/sidebar/css/leaflet-sidebar.css"),
                    # includeCSS("www/plugins/sidebar/css/leaflet-sidebar.min.css"),
                    # includeScript("www/plugins/sidebar/js/leaflet-sidebar.js"),
                    # includeScript("www/plugins/sidebar/js/leaflet-sidebar.min.js"),
                    div(class="outer",
                        tags$style(HTML(
                          "div.outer {
                          position: fixed;
                          top: 146px;
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
                    