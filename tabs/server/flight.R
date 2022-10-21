################################################################################
# Server of the airline information page
#
# Author: Rui Lin
# Created: 18/10/2022 18:03
################################################################################

# Load the data about the energy comsumption
# dataTable <- data.frame(flight_data$airlineCode, data$price, data$departureCity, 
#                         as.Date(data$departureDate), data$departureTime, 
#                         as.Date(data$arrivalDate), data$arrivalTime, 
#                         data$duration.hour, data$arrivalAirport,
#                         data$stop, data$additionalServicesType, 
#                         data$additionalServicesAmount)


# The datatable airline information object
table <- NULL
print("start rendering")
output$mytable = renderDataTable({
  print("rendering table")
  table <- datatable(dataTable, rownames = FALSE, colnames = c('Airline Code' = 1, 'Price' = 2,
                                                               'Departure City' = 3, 'Departure Date' = 4,
                                                               'Departure Time' = 5, 'Arrival Date' = 6,
                                                               'Arrival Time' = 7, 'Duration/ Hours' = 8,
                                                               'Arrival Airport' = 9, 'Number of Stop' = 10,
                                                               'Additional Services' = 11, 'Additional Services Price' = 12),
                     filter = 'top', options = list(orderClasses = TRUE, scrollX = TRUE, pageLength = 10, autoWidth = TRUE))
})