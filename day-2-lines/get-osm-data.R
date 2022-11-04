#############################################################
# Title:         
# Project:       
# Author:        Jack McDowell <jmcdowell@foursquareitp.com>
# Date Created:  Wed Nov 02 09:30:00 2022
# Description:   
# Input:         
# Output:        
#############################################################


library(sf)
library(osmdata)
library(purrr)

ca_crs <- 2226 #NAD83 / California zone 2 (ftUS)

# Create bounding box
bb_placer <- osmdata::getbb('Placer County, CA')

# Pull layers and convert to sf dataframes
gondolas <-
	opq(bb_placer) %>% 
	add_osm_feature(key = 'aerialway',
									value = 'gondola') %>% 
	osmdata_sf() %>% 
	pluck("osm_lines") %>% 
	st_transform(ca_crs)

chairlifts <-
	opq(bb_placer) %>% 
	add_osm_feature(key = 'aerialway',
									value = 'chair_lift') %>% 
	osmdata_sf() %>% 
	purrr::pluck("osm_lines") %>% 
	st_transform(ca_crs)

cablecar <-
	opq(bb_placer) %>% 
	add_osm_feature(key = 'aerialway',
									value = 'cable_car') %>% 
	osmdata_sf() %>% 
	purrr::pluck("osm_lines") %>% 
	st_transform(ca_crs)


# Export
write_sf(gondolas,
				 dsn = file.path("C:/Users/JackMcDowell/Documents/Jack Personal/Code/map-challenge-2022",
												 "day-2-lines",
												 "data",
												 "gondolas.shp"))

write_sf(chairlifts,
				 dsn = file.path("C:/Users/JackMcDowell/Documents/Jack Personal/Code/map-challenge-2022",
				 								"day-2-lines",
				 								"data",
				 								"chairlifts.shp"))

write_sf(cablecar,
				 dsn = file.path("C:/Users/JackMcDowell/Documents/Jack Personal/Code/map-challenge-2022",
				 								"day-2-lines",
				 								"data",
				 								"cablecar.shp"))

