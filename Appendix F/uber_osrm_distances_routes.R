#Using OSRM to get the distances, get the lat-long pairs of a route and visualizing it through Leaflet.
#Example of BKC to Borivali. 
#import the file
BKC_to_residential<-read.csv("/Users/Harsh/Desktop/Uber_Movement/mumbai/BKC/mumbai_weekday_BKC_to_residential_pm_final.csv", header = TRUE)
BKC_to_residential <- BKC_to_residential[order(BKC_to_residential$dstid),] 
library("osrm")
library("geosphere")
#calculate distance between BKC and Borivali
library(sp)
my_route_d<-osrmRoute(src = BKC_to_residential[2,c("sourceid","lng_o","lat_o")],dst = BKC_to_residential[2,c("sourceid","lng_d","lat_d")], sp=TRUE)
library(sp)
plot(my_route_d[,1:2],lty=2,asp=1)
plot(my_route_d, lty = 2, asp = 1, col = "red", add = T)
my_route_cords<-my_route_d@lines[[1]]@Lines[[1]]@coords
route_coords<-data.frame(my_route_cords)
citation("sp")
#export the lat-long pairs of a route
write.csv(route_coords,"/Users/Harsh/Desktop/Uber_Movement/mumbai/BKC/BKC_to_Borivali.csv")

# route segments if needed to draw a polyline
library(leaflet)
leaflet(my_route_d@lines[[1]]@Lines[[1]]@coords) %>% 
  addTiles(attribution = "IDFC Institute | Uber Movement Data © 2018") %>% 
  addMarkers(lng=my_route_d@lines[[1]]@Lines[[1]]@coords[[1]],lat =  my_route_d@lines[[1]]@Lines[[1]]@coords[[1,2]], label = "Origin",labelOptions = labelOptions(noHide = T, textsize = "15px"))%>% 
  addCircleMarkers(lng = my_route_d@lines[[1]]@Lines[[1]]@coords[[length(my_route_cords)/2]],lat =  my_route_d@lines[[1]]@Lines[[1]]@coords[[length(my_route_cords)/2,2]], label = "Destination",labelOptions = labelOptions(noHide = T, textsize = "15px")) %>% 
  addPolylines(data = route_coords, lng = route_coords$lon, lat = route_coords$lat, 
               label = paste(as.character(round(my_route_d$distance,2)), "KM,", as.character(round(BKC_to_residential$average_travel_time[27]/60,2)),
                             "Minutes", sep=" "),labelOptions = labelOptions(noHide = T, textsize = "12px"))
