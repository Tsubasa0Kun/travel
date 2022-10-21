################################################################################
# Server of the map page
#
# Author: Dongli He
# Created: 13/10/2022 16:13
################################################################################

# The leaflet map object
map <- NULL

output$mymap <- renderLeaflet({

  # Generate basemap
  map <- leaflet(event_data) %>%
    addTiles() %>%
    addMarkers(layerId=~title, lng=~longitude, lat=~latitude, popup=~title,
               # clusterOptions=markerClusterOptions()
               ) %>%
    
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
    
    leaflet::addEasyButton(
      easyButton(
        icon = icon("location-arrow"),
        title = "Reset Zoom",
        onClick = JS(c("function(btn, map) {map.setView(new L.LatLng(-37.81, 144.96), 13);}"))
      )
    ) %>%
    
    leaflet::addMiniMap(
      tiles = providers$Esri.WorldGrayCanvas,
      toggleDisplay = TRUE,
      minimized = TRUE,
      position = "bottomleft")# %>%
    
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

})


observeEvent(input$mymap_marker_click, {
  event_name <- input$mymap_marker_click$id
  # openSidebar(map, "home")
  print(event_name)

  event_data <- event_data %>%
    filter(title == event_name)
  
  output$contents <- renderUI({
    div(
      tags$style(HTML(
        ".line-break {
        white-space: pre-line;
        }")),
      img(src=paste0("img/event_images/", event_data$thumb_path), align = "center"),
      h4("Title"),
      p(event_name),
      h4("Description"),
      p(event_data$summary),
      h4("Location"),
      p(class = "line-break",
        stri_join_list(event_data$location, "")),
      h4("Price"),
      p(stri_join_list(event_data$price, "")),
    )
  })
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
