################################################################################
# Server of the map page
#
# Author: Dongli He
# Created: 13/10/2022 16:13
################################################################################

# The leaflet map object
map <- NULL
print("outside rendering functions")
output$hoodInfo <- renderUI({
  print("render UI")
})
output$mymap <- renderLeaflet({
  print("render map")
  
  # Generate basemap
  map <- leaflet(event_data) %>%
    addTiles() %>%
    addMarkers(layerId=~title, lng=~longitude, lat=~latitude, popup=~title,
               clusterOptions=markerClusterOptions())
  # addSidebar(map, id = "sidebar", options = list(position = "left"))
  # openSidebar(map, sidebar)
  # Add legend to map
  # addLegend(pal = pal,
  #           values = valByCountry$TargetByCountry,
  #           position = "bottomleft")
  # addSidebar(map, id = "sidebar")
  # openSidebar(map, "sidebar")
})

# 
#   observeEvent(input$map_marker_click, {
#     event_name <- input$map_marker_click$id
#     # openSidebar(map, "home")
#     # print(event_name)
#   })
# 
#   observeEvent(input$map_click, {
#     # closeSidebar(map)
#   })