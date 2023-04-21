library(sf)
library(dplyr)
library(tidyverse)

#poligonos <- st_read("capas/capas_municba/mejorvivir22/poligonos_edicion/Polygon_layer.shp")
estaciones <- st_read("shapefile-de-eess-res-1104-/shapefile-de-eess-res-1104--shp.shp")
precios <- read.csv("data/estaciones_cba.csv")



estaciones_cba <- estaciones %>% 
  filter(PROVINCIA == "CORDOBA" & LOCALIDAD == "CORDOBA")

CUIT_DIF1 <- estaciones_cba %>% 
  count(DIRECCION , sort = T) 

nrow(estaciones_cba[duplicated(estaciones_cba), ])


precios_estaciones <- left_join(estaciones_cba, precios, by = c("DIRECCION" = "direccion"))

precios_missing <- anti_join(precios, precios_estaciones)
