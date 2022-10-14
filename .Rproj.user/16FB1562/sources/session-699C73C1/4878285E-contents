################################################################################
# Contents of the map
#
# Author: Dongli He
# Created: 13/10/2022 19:14
################################################################################

map <- tabPanel(title = "Map", 
                value = "map",
                br(), hr(),
                div(class="outer",
                    tags$head(includeCSS("map_styles.css")),
                    leafletOutput("mymap", height = 600),
                    htmlOutput("hoodInfo")
                ),
                absolutePanel(id = "controls", class = "panel panel-default",
                              top = 75, left = 55, width = 250, fixed=TRUE,
                              draggable = TRUE, height = "auto",
                              
                              span(tags$i(h6("Reported cases are subject to significant variation in testing policy and capacity between countries.")), style="color:#045a8d"),
                              h3(textOutput("reactive_case_count"), align = "right"),
                              h4(textOutput("reactive_death_count"), align = "right"),
                              h6(textOutput("clean_date_reactive"), align = "right"),
                              h6(textOutput("reactive_country_count"), align = "right"),
                              plotOutput("epi_curve", height="130px", width="100%"),
                              plotOutput("cumulative_plot", height="130px", width="100%"),
                              
                              sliderTextInput("plot_date",
                                              label = h5("Select mapping date"),
                                              choices = format(unique(cv_cases$date), "%d %b %y"),
                                              selected = format(current_date, "%d %b %y"),
                                              grid = FALSE,
                                              animate=animationOptions(interval = 3000, loop = FALSE))
                              
                ),
)
