#Using the Mumbai Hexclusters JSON file provided by Uber Movement to:
#Calculate the centroid of each polygon which gives a lat-long pair for each TAZ.

#load geojson file
library(jsonlite)
library(geosphere)
#load objects
my_mumbai_regions<-jsonlite::fromJSON("/Users/Harsh/Desktop/Uber_Movement/mumbai/mumbai_hexclusters.json")
#check the region list and storing information about each region
mumbai_regions_info<-my_mumbai_regions$features$properties
mumbai_regions_info<-data.frame(mumbai_regions_info)
#polygon coordinates for each region
#storing the polygon coordinates as a list
polygon_coordinates<-my_mumbai_regions$features$geometry$coordinates
#mapping the 'sourceid' and 'dstid' into regions
my_mumbai_polygons<-my_mumbai_regions$features$geometry$coordinates
mumbai_polygons<-as.data.frame(my_mumbai_polygons)
#testing one polygon out of the 695 regions in Mumbai
my_temp_poly<-my_mumbai_polygons[[112]]
poly_len<-length(my_temp_poly)/2
poly_df<- data.frame(lng=my_temp_poly[1,1:poly_len,1], lat=my_temp_poly[1,1:poly_len,2])
my_poly_matrix<-data.matrix(poly_df)
temp_centroid<-centroid(my_poly_matrix)
#visualizing the centroid of the region
#install.packages("leaflet")
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
  addPolygons(lng=my_mumbai_centroids$lng[1:10] , lat=my_mumbai_centroids$lat[1:10])
