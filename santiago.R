library(sf)
library(dplyr)
library(tidyverse)

estaciones <- st_read("shapefile-de-eess-res-1104-/shapefile-de-eess-res-1104--shp.shp")
#precios <- read.csv("data/precios-en-surtidor-resolucin-3142016.csv")
precios <- st_read("data/precios-en-surtidor-resolucin-3142016.csv")
preciosyvolumenes <- st_read("data/precios-y-volumenes-a-partir-de-2018.csv")

preciosyvolumenes <- st_as_sf(preciosyvolumenes, coords = c("longitud", "latitud"), crs = 4326)

preciosyvolumenes_santiago <- preciosyvolumenes %>%
  filter(Provincia == "SANTIAGO DEL ESTERO")

precios_geo <- precios %>% 
  filter(!is.na(latitud))

precios_santiago_geo <- st_as_sf(precios_santiago, coords = c("longitud", "latitud"), crs = 4326)

estaciones_santiago <- estaciones %>% 
  filter(PROVINCIA == "SANTIAGO DEL ESTERO") %>% 
  mutate(id_estacion = row_number())

precios_santiago <- precios %>% 
  filter(provincia == "SANTIAGO DEL ESTERO")


st_write(precios_santiago_geo, "data/precios_santiago.shp")
write.csv(precios_santiago, "data/precios_santiago.csv")
write.csv(estaciones_santiago, "data/estaciones_santiago.csv")

estaciones_santiago$lon <- st_coordinates(estaciones_santiago)[,1]
estaciones_santiago$lat <- st_coordinates(estaciones_santiago)[,2]
estaciones_santiago <- estaciones_santiago %>%  st_set_geometry(NULL)

estaciones_santiago1 <- estaciones_santiago %>% 
  st_buffer(dist = 20) 


#join st_within precios por estacion
preciosxestacion <- st_join(precios_santiago_geo, estaciones_santiago1, join = st_within)

preciosxestacion1 <- preciosxestacion %>% 
  st_set_geometry(NULL) %>% 
  select(-c("localidad", "provincia", "region", "LOCALIDAD", "CUIT", "DIRECCION", "PROVINCIA"))

preciosxestacion1 <- preciosxestacion1 %>% 
  filter(!is.na(id_estacion))

estaciones_santiago$lon <- st_coordinates(estaciones_santiago)[,1]
estaciones_santiago$lat <- st_coordinates(estaciones_santiago)[,2]
estaciones_santiago <- estaciones_santiago %>%  st_set_geometry(NULL)


write.csv(preciosxestacion1, "data/preciosxestacion2.csv")
