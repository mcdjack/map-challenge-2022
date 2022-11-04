#############################################################
# Title:         
# Project:       
# Author:        Jack McDowell <jmcdowell@foursquareitp.com>
# Date Created:  Thu Nov 03 19:21:46 2022
# Description:   
# Input:         
# Output:        
#############################################################


library(dplyr)
library(sf)

dir_path <- "C:/Users/JackMcDowell/Documents/Jack Personal/Code/map-challenge-2022/day-3-polygons"

crs <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# High points
us_high_pts <-
  read_sf(dsn = file.path(dir_path,
                          "data",
                          "51_high_points.kml")) %>% 
  st_transform(crs)


# US boundary
us_lower48 <-
  tigris::states(cb = TRUE,
                 class = "sf") %>% 
  filter(!(STUSPS %in% c("AK","HI","AS","MP","VI","GU","PR"))) %>% 
  st_transform(crs) %>% 
  st_union()

bbox_polygon <- function(x) {
  bb <- sf::st_bbox(x)
  
  p <- matrix(
    c(bb["xmin"], bb["ymin"], 
      bb["xmin"], bb["ymax"],
      bb["xmax"], bb["ymax"], 
      bb["xmax"], bb["ymin"], 
      bb["xmin"], bb["ymin"]),
    ncol = 2, byrow = T
  )
  
  sf::st_polygon(list(p))
}

box <- st_sfc(bbox_polygon(us_lower48))


# Voronoi
voronoi_high_pts <-
  st_voronoi(st_union(us_high_pts), box)

voronoi_high_pts <-
  st_intersection(st_cast(voronoi_high_pts),us_lower48) %>% 
  st_transform(crs)

mapview(voronoi_high_pts, viewer.suppress = T)


# Export
write_sf(voronoi_high_pts,
         file.path(dir_path,
                   "data",
                   "voronoi_high_pts.shp"))
