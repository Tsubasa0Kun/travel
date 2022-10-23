################################################################################
# Server of the map page
#
# Author: Dongli He, Louhao Fang
# Created: 13/10/2022 16:13
################################################################################

# The leaflet map object
map <- NULL

shinyjs::hide(id = "popup_panel")

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

eventsFilter <- reactive({
  eventsHeadingSelected <<- input$EventHeading
  eventsMonthSelected <<- input$EventMonth
  if(is.null(eventsHeadingSelected))
  {
    eventsHeadingSelected <<- c("Theatre", "Festivals", "Exhibitions", "Live music and gigs", "Expos", "Sport", "Family events")
    updateCheckboxGroupInput(session, "EventHeading", selected = eventsHeadingSelected)
  }
  
  if(is.null(eventsMonthSelected))
  {
    eventsMonthSelected <<- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    updateCheckboxGroupInput(session, "EventMonth", selected = eventsMonthSelected)
  }
  
  filter1 <- data.frame(filter(event_data, FALSE))
  for (eventMonth in eventsMonthSelected)
  {
    filter1 <- union(filter1, filter(event_data, event_data[eventMonth] == 1))
  }
  
  filter2 <- filter(filter1, heading %in% eventsHeadingSelected)
  filter2
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
    map <- addMarkers(map, data = eventsFilter(), layerId = ~title, lng = ~longitude, lat = ~latitude,
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
    h3("Eating out"),
    hr(),
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
    h3("Hotels"),
    hr(),
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


observeEvent(input$filterForEvents, {
  showModal(modalDialog(
    h3("Events"),
    hr(),
    checkboxGroupInput(
      label = "Heading",
      inputId = "EventHeading",
      choices = c("Theatre", "Festivals", "Exhibitions", "Live music and gigs", "Expos", "Sport", "Family events"),
      selected = eventsHeadingSelected
    ),
    checkboxGroupInput(
      label = "Month",
      inputId = "EventMonth",
      choices = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
      selected = eventsMonthSelected
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
  print('open')
  shinyjs::show(id = "popup_panel")
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
        img(src=paste0(data$images), style = "width:330px;height:auto;",
            align = "center"),
        p(name, style="color:#08424b;font-weight:bold;font-size:18px;margin-left:12px;margin-top:15px"),
        p(data$intro, style="font-size:14px;margin-left:12px;margin-top:5px;margin-right:5px;"),
        hr(),
        h4("Tags"),
        p(eatingTags),
        h4("Cuisine"),
        p(cuisines),
        h4("Price"),
        p(data$price),
        h4("Attribution"),
        p(data$attribution),
        hr(),
        )
    })
  }
  else if(first_char == "2")
  {
    data <- filter(hotels, name == click$id)[1,]
    icon <- HotelIconBig
    output$contents <- renderUI({
      div(
        tags$style(HTML(
          ".line-break {
          white-space: pre-line;
          }")),
        img(src = paste0(data$images), style = "width:330px;height:auto;",
            align = "center"),
        p(name, style="color:#08424b;font-weight:bold;font-size:18px;margin-left:12px;margin-top:15px"),
        p(data$intro, style="font-size:14px;margin-left:12px;margin-top:5px;margin-right:5px;"),
        hr(),
        h4("Price"),
        p(data$price),
        h4("Attribution"),
        p(data$attribution),
        hr(),
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
        img(src = paste0("img/event_images/", data$thumb_path),
            style = "width:330px;height:250px;", align = "center"),
        p(name, style="color:#08424b;font-weight:bold;font-size:18px;margin-left:12px;margin-top:15px"),
        p(data$summary, style="font-size:14px;margin-left:12px;margin-top:5px;margin-right:5px;"),
        hr(),
        h4("Address"),
        p(class = "line-break",
          stri_join_list(data$location, "")),
        h4("Price"),
        p(stri_join_list(data$price, "")),
        h4("Time"),
        p(data$from_to_date),
        hr(),
      )
    })
  }
  
  leafletProxy("mymap") %>%
    addMarkers(layerId="Selected", lng=click$lng, lat=click$lat, icon = icon,
               group = "Selected",  options = pathOptions(pane = "Selected"))
    
})

observeEvent(input$mymap_click, {
  shinyjs::hide(id = "popup_panel")
})
