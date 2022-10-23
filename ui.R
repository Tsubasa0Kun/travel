################################################################################
# UI of the app
#
# Author: Dongli He
# Created: 9/10/2022 14:50
################################################################################

# ui <- fluidPage(
#   # Set up shinyjs
#   useShinyjs(),
#   
#   # Remove padding
#   style = "padding:0px;",
#   
#   # Make navbar float to the right
#   tags$head(tags$style(HTML(".navbar .navbar-nav {float: right};"))),
# 
#   navbarPage(
#     "Melbourne Exploration",
#     # ----------------------------------
#     # tab panel 1 - Home
#     tabPanel(
#       "Home",
#       includeHTML("index.html"),
#       tags$script(
#         src = "plugins/custom.js"),
#       tags$head(
#          tags$link(
#            rel = "stylesheet",
#            type = "text/css",
#            href = "plugins/fontawesome-free-6.2.0-web/css/font-awesome.min.css"),
#          tags$link(
#            rel = "stylesheet",
#            type = "text/css",
#            href = "plugins/custom.css"),
#       )
#     ),
#     
#     tabPanel(
#       "Map",
#       fluidRow(
#         column(3,
#                HTML(
#                '<div id="sidebar" class="sidebar collapsed">
#                 <!-- navigation tabs -->
#                 <div class="sidebar-tabs">
#                 <ul role="tablist">
#                 <li>
#                 <a href="#home" role="tab"><i class="fa fa-bars"></i></a>
#                 </li>
#                 </ul>
#                 </div>
#                 <!-- tab panes -->
#                 <div class="sidebar-content">
#                 <div class="sidebar-pane" id="home">
#                 <h1 class="sidebar-header">
#                 Welcome to Melbourne
#                 <span class="sidebar-close">
#                 <i class="fa fa-caret-left"></i>
#                 </span>
#                 </h1>
#                 <p>Pane text</p>
#                 </div>
#                 <div class="sidebar-pane" id="event_info">
#                 <h1 class="sidebar-header">
#                 Event
#                 <span class="sidebar-close">
#                 <i class="fa fa-caret-left"></i>
#                 </span>
#                 </h1>
#                 <p>Pane text</p>
#                 </div>
#                 </div>
#                 </div>'
#                )
#         )
#       ),
#       leafletOutput("map", height=1000),
#     ),
#     
#     tabPanel(
#       "About",
#       includeHTML("about.html"),
#       # tags$head(
#       #   tags$link(
#       #     rel = "stylesheet",
#       #     type = "text/css",
#       #     href = "plugins/carousel.css"),
#       # ),
#       tags$style(
#         type="text/css",
#         ".shiny-output-error { visibility: hidden; }",
#         ".shiny-output-error:before { visibility: hidden; }"
#       )
#     ),
#   )
# )

shinyUI(
  fluidPage(
    # Set up shinyjs
    useShinyjs(),
    ##-- icon ----
    tags$head(
      tags$link(rel = "shortcut icon", href = "img/logo.ico"),
      #-- biblio js ----
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro")
    ),
    ##-- Logo ----
    list(tags$head(HTML('<link rel="icon", href="img/logo.png",
                        type="image/png" />'))),
    div(style="padding: 1px 0px; width: '100%'",
        titlePanel(
          title="", windowTitle = "MELBOURNE DISCOVERY"
        )
    ),
    ##-- Header ----
    navbarPage(title = div(img(src="img/logo.png",
                               height = "75px"), style = "padding-left:100px;"),
               id = "navbar",
               selected = "home",
               theme = "styles.css",
               windowTitle = "Melbourne Discovery",
               fluid = T,
               ##-- navigation pages ----
               home,
               airline_info_container,
               map_container,
               about,
    ),
  )
)