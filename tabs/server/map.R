################################################################################
# Server of the map page
#
# Author: Dongli He
# Created: 13/10/2022 16:13
################################################################################

# The leaflet map object
map <- NULL
print("start rendering")
output$mymap <- renderLeaflet({
  print("rendering map")

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

})




observeEvent(input$mymap_marker_click, {
  event_name <- input$mymap_marker_click$id
  # openSidebar(map, "home")
  print(event_name)
  print(10086)
  title <- HTML(event_name)
  event_data <- event_data %>%
    filter(title == event_name)
  output$contents <- renderUI({
    print(123)
    "contents"
  })

})
  

# 
#   observeEvent(input$mymap_click, {
#     # closeSidebar(map)
#   })