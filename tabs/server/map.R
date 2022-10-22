################################################################################
# Server of the map page
#
# Author: Dongli He, Louhao Fang
# Created: 13/10/2022 16:13
################################################################################

# The leaflet map object
map <- NULL


ifEatingout <- reactive({
  res <- ifelse(input$eatingout, 1, 0)
})

ifHotel <- reactive({
  res <- ifelse(input$hotels, 1, 0)
})

ifEvent <- reactive({
  res <- ifelse(input$events, 1, 0)
})


eatingFilter <- reactive({
  eatingTagsSelected <<- input$EatingTags
  eatingScoreSelected <<- input$EatingScore
  eatingPriceSelected <<- input$EatingPrice
  if(is.null(eatingTagsSelected))
  {
    eatingTagsSelected <<- c('breakfast', 'lunch', 'dinner', 'drinks', 'coffee', 'icecream')
    updateCheckboxGroupInput(session, "EatingTags", selected = eatingTagsSelected)
  }
  if(is.null(eatingScoreSelected))
  {
    eatingScoreSelected <<- c(0, 1, 2, 3, 4)
    updateCheckboxGroupInput(session, "EatingScore", selected = eatingScoreSelected)
  }
  if(is.null(eatingPriceSelected))
  {
    eatingPriceSelected <<- c("cheap", "medium", "expensive")
    updateCheckboxGroupInput(session, "EatingPrice", selected = eatingPriceSelected)
  }
  
  filter1 <- data.frame(filter(eatingout, FALSE))
  for (eatingTag in eatingTagsSelected)
  {
    filter1 <- union(filter1, filter(eatingout, eatingout[eatingTag] == 1))
  }
  
  filter2 <- filter(filter1, price %in% eatingPriceSelected)
  
  filter3 <- data.frame(filter(filter2, FALSE))
  for(eatingScore in eatingScoreSelected)
  {
    filter3 <- union(filter3, filter(filter2, score >= strtoi(eatingScore), score < strtoi(eatingScore) + 1))
  }
  filter3
})

hotelsFilter <- reactive({
  hotelsScoreSelected <<- input$HotelsScore
  hotelsPriceSelected <<- input$HotelsPrice
  if(is.null(hotelsScoreSelected))
  {
    hotelsScoreSelected <<- c(0, 1, 2, 3, 4)
    updateCheckboxGroupInput(session, "HotelsScore", selected = hotelsScoreSelected)
  }
  if(is.null(hotelsPriceSelected))
  {
    hotelsPriceSelected <<- c("cheap", "medium", "expensive")
    updateCheckboxGroupInput(session, "HotelsPrice", selected = hotelsPriceSelected)
  }
  
  filter2 <- filter(hotels, price %in% hotelsPriceSelected)
  
  filter3 <- data.frame(filter(filter2, FALSE))
  for(hotelScore in hotelsScoreSelected)
  {
    filter3 <- union(filter3, filter(filter2, score >= strtoi(hotelScore), score < strtoi(hotelScore) + 1))
  }
  filter3
})


output$mymap <- renderLeaflet({
  
  
  # Generate basemap
  map <- leaflet(options = leafletOptions(doubleClickZoom= FALSE)) %>%
    addTiles() %>%
    
    # leaflet::addControl(html = sidebar_HTML, position = "topright") %>%
    
    # htmlwidgets::onRender(
    #   htmlwidgets::JS("
    #     function(el, x) {
    #     map = this;
    #     var sidebar = L.control.sidebar({
    #     autopan: false,
    #     position: 'right',
    #     container: 'sidebar',
  #     closeButton: true
  #     }).addTo(map).open('home');
  #     }")) %>%
  
  leaflet.extras::addFullscreenControl() %>%
    
    setView(lng = 145, lat = -37.811722, zoom = 10) %>%
    
    addMapPane("Selected", zIndex = 1000) %>%
    
    leaflet::addEasyButton(
      easyButton(
        icon = icon("location-arrow"),
        title = "Reset Zoom",
        onClick = JS(c("function(btn, map) {map.setView(new L.LatLng(-37.81, 144.96), 10);}"))
      )
    ) %>%
    
    leaflet::addMiniMap(
      tiles = providers$Esri.WorldGrayCanvas,
      toggleDisplay = TRUE,
      minimized = TRUE,
      position = "bottomleft")# %>%
  
  if(ifEvent())
  {
    map <- addMarkers(map, data = event_data, layerId = ~title, lng = ~longitude, lat = ~latitude,
                      clusterOptions=markerClusterOptions(), icon = EventIcon, group = "events")
  }
  # Add the control widget
  # leaflet::addLayersControl(overlayGroups = c(
  #   "<img src = 'iconno.png' height = '12' width = '31'> Response vessels",
  #   "<img src = 'icondisper.png' height = '12' width = '31'> Response vessels with dispersants",
  #   "<img src = 'iconstock.png' height = '10' width = '31'> Dispersant stockpile",
  #   "<img src = 'iconeas.png' height = '13' width = '31'> EAS stockpile",
  #   "<img src = 'iconeumembers.png' height = '15' width = '31'> EU member countries",
  #   "<img src = 'iconeucandidates.png' height = '15' width = '31'> EU candidate countries",
  #   "<img src = 'iconeuefta.png' height = '15' width = '31'> EEU/EFTA coastal countries"),                       
  #   baseGroups = c("Map 1", "Map 2"), 
  #   options = markerOptions(riseOnHover = TRUE),
  #   position = "topright")
  # openSidebar(map, "home", "sidebar")
  # addSidebar(map, id = "sidebar", options = list(position = "left"))
  # openSidebar(map, sidebar)
  # Add legend to map
  # addLegend(pal = pal,
  #           values = valByCountry$TargetByCountry,
  #           position = "bottomleft")
  
  if(ifHotel())
  {
    map <- addMarkers(map, data = hotelsFilter(), layerId=~name, lng=~longitude, lat=~latitude,
                      clusterOptions=markerClusterOptions(), icon = HotelIcon, group = "hotels")
  }
  
  
  if(ifEatingout())
  {
    map <- addMarkers(map, data = eatingFilter(), layerId=~name, lng=~longitude, lat=~latitude,
                      clusterOptions=markerClusterOptions(), icon = EatingIcon, group = "eatingout")
  }
  
  map
  
})

observeEvent(input$filterForEatingout, {
  showModal(modalDialog(
    checkboxGroupInput(
      label = "Score",
      inputId = "EatingScore",
      choiceNames = c('0~1', '1~2', '2~3', '3~4', '4~5'),
      choiceValue = c(0, 1, 2, 3, 4),
      selected = eatingScoreSelected
    ),
    checkboxGroupInput(
      label = "Tags",
      inputId = "EatingTags",
      choices = c('breakfast', 'lunch', 'dinner', 'drinks', 'coffee', 'icecream'),
      selected = eatingTagsSelected
    ),
    checkboxGroupInput(
      label = "Price",
      inputId = "EatingPrice",
      choices = c("cheap", "medium", "expensive"),
      selected = eatingPriceSelected
    ),
    easyClose = TRUE,
    footer = fluidRow(align="center",
                      actionButton("modalHide", "Hide"),
    )
  ))
})

observeEvent(input$filterForHotels, {
  showModal(modalDialog(
    checkboxGroupInput(
      label = "Score",
      inputId = "HotelsScore",
      choiceNames = c('0~1', '1~2', '2~3', '3~4', '4~5'),
      choiceValue = c(0, 1, 2, 3, 4),
      selected = hotelsScoreSelected
    ),
    checkboxGroupInput(
      label = "Price",
      inputId = "HotelsPrice",
      choices = c("cheap", "medium", "expensive"),
      selected = hotelsPriceSelected
    ),
    easyClose = TRUE,
    footer = fluidRow(align="center",
                      actionButton("modalHide", "Hide"),
    )
  ))
})

observeEvent(input$modalHide, {
  removeModal()
})



observeEvent(input$mymap_marker_click, {
  
  click <- input$mymap_marker_click
  if(is.null(click))
    return()
  
  if (click$id == "Selected")
  {
    leafletProxy("mymap") %>%
      clearGroup("Selected")
    return()
  }
  
  first_char <- substr(click$id, 1, 1)
  data <- NULL
  icon <- NULL
  name <- substr(click$id, 2, nchar(click$id))
  if (first_char == "1")
  {
    data <- filter(eatingout, name == click$id)
    icon <- EatingIconBig
    eatingTags <- toString(unlist(str_split(substr(data$Tags, 3, nchar(data$Tags) - 2), "', '")))
    cuisines <- toString(unlist(str_split(substr(data$cuisine, 3, nchar(data$cuisine) - 2), "', '")))
    output$contents <- renderUI({
      div(
        tags$style(HTML(
          ".line-break {
        white-space: pre-line;
        }")),
        img(src=paste0(data$images), align = "center"),
        h4("Name"),
        p(name),
        h4("Tags"),
        p(eatingTags),
        h4("Cuisine"),
        p(cuisines),
        h4("Description"),
        p(data$intro),
        h4("Price"),
        p(data$price),
        h4("attribution"),
        p(data$attribution)
        )
    })
  }
  else if(first_char == "2")
  {
    data <- filter(hotels, name == click$id)
    icon <- HotelIconBig
    output$contents <- renderUI({
      div(
        tags$style(HTML(
          ".line-break {
        white-space: pre-line;
        }")),
        img(src=paste0(data$images), align = "center"),
        h4("Name"),
        p(name),
        h4("Description"),
        p(data$intro),
        h4("Price"),
        p(data$price),
        h4("attribution"),
        p(data$attribution)
      )
    })
  }
  else if(first_char == "3")
  {
    data <- filter(event_data, title == click$id)
    icon <- EventIconBig
    output$contents <- renderUI({
      div(
        tags$style(HTML(
          ".line-break {
        white-space: pre-line;
        }")),
        img(src=paste0("img/event_images/", data$thumb_path), align = "center"),
        h4("Name"),
        p(name),
        h4("Description"),
        p(data$summary),
        h4("Location"),
        p(class = "line-break",
          stri_join_list(data$location, "")),
        h4("Price"),
        p(stri_join_list(data$price, "")),
      )
    })
  }
  
  leafletProxy("mymap") %>%
    addMarkers(layerId="Selected", lng=click$lng, lat=click$lat, icon = icon, group = "Selected",  options = pathOptions(pane = "Selected"))
    
})
  
# sidebar_HTML <- tags$div(HTML('
#                     <div id="sidebar" class="leaflet-sidebar collapsed">
#                         <!-- Nav tabs -->
#                         <div class="leaflet-sidebar-tabs">
#                             <ul role="tablist">
#                                 <li><a href="#home" role="tab"><i class="fa fa-bars"></i></a></li>
#                                 <li><a href="#info" role="tab"><i class="fa fa-info-circle"></i></a></li>
#                                 <li class="disabled"><a href="#messages" role="tab"><i class="fa fa-envelope"></i></a></li>
#                                 <li class="disabled"><a href="#twitter" role="tab" target="_blank"><i class="fa fa-twitter"></i></a></li>
#                             </ul>
#                 
#                             <ul role="tablist">
#                                 <li><a href="#goal" role="tab"><i class="fa fa-gear"></i></a></li>
#                             </ul>
#                         </div>
#                         <!-- Tab panes -->
#                         <div class="leaflet-sidebar-content">
#                             <div class="leaflet-sidebar-pane" id="home">
#                                 <h1 class="leaflet-sidebar-header">Stand-by Oil Spill Response Services*<span class="leaflet-sidebar-close"><i class="fa fa-caret-right"></i></span></h1>
#                                 <p></p>
#                                 <p>*Data are referent to the April 2017</p>
#                                 <p></p>
#                                 <img src = emsa_logo.png height = 21 width = 111>
#                                 <p></p>
#                                 <p class="lorem"><a href="http://www.emsa.europa.eu/" target = "_blank">EMSA</a> has established a network of stand-by oil spill response vessels through contracts with commercial vessel operators. EMSA’s contracted vessels have been specifically adapted for oil spill response operations and are on stand-by, carrying out their usual commercial activities.</p>
#                                 <p class="lorem">In the event of an oil spill, the selected vessel will cease its normal activities and will be made available to the requesting party fully-equipped for oil spill response services under established terms and conditions and tariffs. Following a request for assistance, the maximum time for the oil spill response vessel to be ready to sail is 24 hours.</p>
#                                 <p class="lorem">Regardless of their area of commercial operations, all vessels in the EMSA network can be mobilised for response to an oil spill anywhere in European waters and shared sea basins.</p>
#                                 <p class="lorem">EMSA currently maintains 17 fully equipped stand-by oil spill response vessels around Europe.</p>
#                             </div>
#                 
#                             <div class="leaflet-sidebar-pane" id="info">
#                                 <h1 class="leaflet-sidebar-header">Quick Facts<span class="leaflet-sidebar-close"><i class="fa fa-caret-right"></i></span></h1>
#                                 <p></p>
#                                 <img src = emsa_logo.png height = 21 width = 111>
#                                 <h3>Network of Response Vessels: Quick Facts</h3>
#                                 <p>Number of vessels which can be mobilised simultaneously: 17</p>
#                                 <p>Average storage capacity per vessel for recovered oil: 3.500 m3</p>
#                                 <p>Network storage capacity, if 17 vessels are mobilised: 60.000 m3</p>
#                                 <p>Number of related equipment stockpiles: 17</p>
#                                 <p>Mobilisation time (vessel ready to sail to site) after request: 24 hours</p>
#                                 <p><b>Mobilisation procedure</b>:</p>
#                                 <ul style="list-style-type:disc;">
#                                   <li>Member States request assistance via the <a href="http://ec.europa.eu/echo/en/what/civil-protection/emergency-response-coordination-centre-ercc" target = "_blank">ERCC</a></li>
#                                   <li>Member States have operational control of the vessel during the incident</li>
#                                 </ul>
#                             </div>
#                 
#                             <div class="leaflet-sidebar-pane" id="messages">
#                                 <h1 class="leaflet-sidebar-header">Messages<span class="leaflet-sidebar-close"><i class="fa fa-caret-right"></i></span></h1>
#                             </div>
#                 
#                             <div class="leaflet-sidebar-pane" id="goal">
#                                 <h1 class="leaflet-sidebar-header">Goal Settings<span class="leaflet-sidebar-close"><i class="fa fa-caret-right"></i></span></h1>
#                                 <p></p>
#                                 <p>Transforming the <a href="http://www.emsa.europa.eu/oil-spill-response/oil-recovery-vessels.html" target = "_blank">EMSA´s Operational Oil Pollution Response Services</a> static map into an interacative (georeferenced) map.</p>
#                                 <p><b>Tips</b>:</p>
#                                 <ul style="list-style-type:disc;">
#                                   <li>Click on View Fullscreen</li>
#                                   <li>Click on vessels to get more info</li>
#                                 </ul>
#                             </div>
#                         </div>
#                     </div>
#                           '))

# observeEvent(input$mymap_click, {
#   leaflet.extras2::closeSidebar(map, "sidebar")
# })
