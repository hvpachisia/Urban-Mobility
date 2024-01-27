#input weekly aggregates by day for Q1 2018 Mumbai data file
my_mumbai_mv_wa<-read.csv("/Users/Harsh/Desktop/Uber_Movement/mumbai-hexclusters-2018-1-WeeklyAggregate.csv", header = TRUE)
#Summary of data
str(my_mumbai_mv_wa)
#load geojson file
library(jsonlite)
library(geosphere)
#load objects
my_mumbai_regions<-jsonlite::fromJSON("/Users/Harsh/Desktop/Uber_Movement/mumbai_hexclusters.json")
#check the region list
head(my_mumbai_regions$features$properties)
#polygon coordinates for each region
#storing the polygon coordinates as a list
polygon_coordinates<-my_mumbai_regions$features$geometry$coordinates
#mapping the 'sourceid' and 'dstid' into regions
my_mumbai_polygons<-my_mumbai_regions$features$geometry$coordinates
mumbai_polygons<-as.data.frame(my_mumbai_polygons)
#testing one polygon out of the 695 regions in Mumbai
my_temp_poly<-my_mumbai_polygons[[1]]
poly_len<-length(my_temp_poly)/2
poly_df<- data.frame(lng=my_temp_poly[1,1:poly_len,1], lat=my_temp_poly[1,1:poly_len,2])
my_poly_matrix<-data.matrix(poly_df)
temp_centroid<-centroid(my_poly_matrix)
#visualizing the centroid of the region
install.packages("leaflet")
library(leaflet)
leaflet(temp_centroid) %>% 
  addTiles() %>% 
  addMarkers() %>% 
  addPolygons(lng= poly_df$lng, lat=poly_df$lat)
length(polygon_coordinates)
#now getting the centroid for all polygons-all regions
#creating an empty dataframe for the centroids to be added to
my_mumbai_centroids <- data.frame(matrix(ncol = 3, nrow = 0))
i=1
while (i<=length(polygon_coordinates)) {
  my_poly<-my_mumbai_polygons[[i]]
  poly_length<-length(my_poly)/2
  polygon_df<-data.frame(lng=my_poly[1,1:poly_length,1], lat=my_poly[1,1:poly_length,2])
  my_polygon_matrix<-data.matrix(polygon_df)
  tem_centroid<-centroid(my_polygon_matrix)
  my_mumbai_centroids <-rbind(my_mumbai_centroids, c(id=i,lng=tem_centroid[1][1],lat=tem_centroid[2][1]))
  i=i+1
}
#adding column names
col_names_of_centroids <- c("id", "lng", "lat")
colnames(my_mumbai_centroids) <- col_names_of_centroids
#seeing all the centroids on a map
library(leaflet)
leaflet(my_mumbai_centroids) %>% 
  addTiles() %>% 
  addMarkers() %>% 
  addPolygons(lng=my_mumbai_centroids$lng[1:695] , lat=my_mumbai_centroids$lat[1:695])

#do the work in SQL and merge the two tables
#read in the merged table into R
my_mumbai_od<-read.csv("/Users/Harsh/Desktop/Uber_Movement/mumbai_weekly_OD.csv", header= TRUE)
str(my_mumbai_od)

library(spatstat)
## create a point pattern object
#not sure of this yet- code is unstable
#my_mumbai_centroids_pp<-ppp(my_mumbai_centroids[,2],my_mumbai_centroids[,3],c(72.86738,73.07799),c(19.28809,19.05419))
#visualize density
#plot(density(my_mumbai_centroids_pp))

#load osrm to get the distances
install.packages("osrm")
library("osrm")

#calculate distance between test origin and destination- Test Case 1
my_route_d<-osrmRoute(src = my_mumbai_od[1,c("sourceid","lng_o","lat_o")],dst = my_mumbai_od[1,c("sourceid","lng_d","lat_d")], sp=TRUE)
install.packages("sp")
library(sp)
plot(my_route_d[,1:2],lty=2,asp=1)
plot(my_route_d, lty = 2, asp = 1, col = "red", add = T)
my_route_cords<-my_route_d@lines[[1]]@Lines[[1]]@coords
route_coords<-data.frame(my_route_cords)
my_route_d$distance
# route segments if needed to draw a polyline
leaflet(my_route_d@lines[[1]]@Lines[[1]]@coords) %>% 
  addTiles(attribution = "Uber Movement Data © 2018") %>% 
  addMarkers(my_route_d@lines[[1]]@Lines[[1]]@coords[[1]],lat =  my_route_d@lines[[1]]@Lines[[1]]@coords[[1,2]], label = "Origin",labelOptions = labelOptions(noHide = T, textsize = "15px"))%>% 
  addCircleMarkers(lng = my_route_d@lines[[1]]@Lines[[1]]@coords[[18]],lat =  my_route_d@lines[[1]]@Lines[[1]]@coords[[18,2]],label = "Destination",labelOptions = labelOptions(noHide = T, textsize = "15px")) %>% 
  addPolylines(data = route_coords, lng = route_coords$lon, lat = route_coords$lat, 
               label = paste(as.character(round(my_route_d$distance,2)), "KM,", as.character(round(my_mumbai_od$mean_travel_time[1]/60,2)),
                             "Minutes,", "DOW",as.character(my_mumbai_od$dow[1]), sep=" "),labelOptions = labelOptions(noHide = T, textsize = "12px"))
  
str(my_route_d$distance)
paste(as.character(round(my_route_d$distance,2)), "KM,", as.character(round(my_mumbai_od$mean_travel_time[1]/60,2)),
      "Minutes,", "DOW",as.character(my_mumbai_od$dow[1]), sep=" ")

#calculate distance between test origin and destination- Test Case 2
my_route_d2<-osrmRoute(src = my_mumbai_od[45222,c("sourceid","lng_o","lat_o")],dst = my_mumbai_od[45222,c("sourceid","lng_d","lat_d")], sp=TRUE)
install.packages("sp")
library(sp)
plot(my_route_d2[,1:2],lty=2,asp=1)
plot(my_route_d, lty = 2, asp = 1, col = "red", add = T)
my_route_cords2<-my_route_d2@lines[[1]]@Lines[[1]]@coords
route_coords2<-data.frame(my_route_cords2)
my_route_d2$distance
length(my_route_cords2)
# route segments if needed to draw a polyline
leaflet(my_route_d2@lines[[1]]@Lines[[1]]@coords) %>% 
  addTiles(attribution = "Uber Movement Data © 2018") %>% 
  addMarkers(lng= my_route_d2@lines[[1]]@Lines[[1]]@coords[[1]],lat =  my_route_d2@lines[[1]]@Lines[[1]]@coords[[1,2]], label = "Origin",labelOptions = labelOptions(noHide = T, textsize = "15px"))%>% 
  addCircleMarkers(lng = my_route_d2@lines[[1]]@Lines[[1]]@coords[[length(my_route_cords2)/2]],lat =  my_route_d2@lines[[1]]@Lines[[1]]@coords[[length(my_route_cords2)/2,2]],label = "Destination",labelOptions = labelOptions(noHide = T, textsize = "15px")) %>% 
  addPolylines(data = route_coords2, lng = route_coords2$lon, lat = route_coords2$lat, 
               label = paste(as.character(round(my_route_d2$distance,2)), "KM,", as.character(round(my_mumbai_od$mean_travel_time[45222]/60,2)),
                             "Minutes,", "DOW",as.character(my_mumbai_od$dow[45222]), sep=" "),labelOptions = labelOptions(noHide = T, textsize = "12px"))
