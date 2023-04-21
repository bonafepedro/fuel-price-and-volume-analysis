library(sf)
library(dplyr)
library(tidyverse)
library(writexl)

# lo comentamos porque los json del request obtienen menos datos que los csv
# todo es bronca y dolor.
# precios2012 <- read.csv("data/prueba2012.csv")
# precios2013 <- read.csv("data/prueba2013.csv")
# precios2014 <- read.csv("data/prueba2014.csv")
# precios2015 <- read.csv("data/prueba2015.csv")
# precios2016 <- read.csv("data/prueba2016.csv")
# precios2017 <- read.csv("data/prueba2017.csv")
# precios2018 <- read.csv("data/prueba2018.csv")
# precios2019 <- read.csv("data/prueba2019.csv")
# precios2020 <- read.csv("data/prueba2020.csv")
# precios2021 <- read.csv("data/prueba2021.csv")
# precios2022 <- read.csv("data/prueba2022.csv")
# precios2023 <- read.csv("data/prueba2023.csv")



preciosyv2012 <- read.csv("data1/precios-eess-2012.csv", dec=".")
preciosyv2013 <- read.csv("data1/precios-eess-2013.csv", dec=".")
preciosyv2014 <- read.csv("data1/precios-eess-2014.csv", dec=".")
preciosyv2015 <- read.csv("data1/precios-eess-2015.csv", dec=".")
preciosyv2016 <- read.csv("data1/precios-eess-2016.csv", dec=".")
preciosyv2017 <- read.csv("data1/precios-eess-2017.csv", dec=".")
preciosyv2018 <- read.csv("data1/precios-eess-2018.csv", dec=".")
preciosyv2019 <- read.csv("data1/precios-eess-2019.csv", dec=".")
preciosyv2020 <- read.csv("data1/precios-eess-2020.csv", dec=".") 
preciosyv2021 <- read.csv("data1/precios-eess-2021.csv", dec=".")
preciosyv2022 <- read.csv("data1/precios-eess-2022.csv", dec=".")
preciosyv2023 <- read.csv("data1/precios-eess-2023.csv", dec=".")



# 
# precios2012_TOTAL <- read.csv("data/df2012_TOTAL.csv")
# precios2013_TOTAL <- read.csv("data/df2013_TOTAL.csv")
# precios2014 <- read.csv("data/prueba2014.csv")
# precios2015 <- read.csv("data/prueba2015.csv")
# precios2016 <- read.csv("data/prueba2016.csv")
# precios2017 <- read.csv("data/prueba2017.csv")
# precios2018 <- read.csv("data/prueba2018.csv")
# precios2019 <- read.csv("data/prueba2019.csv")
# precios2020 <- read.csv("data/prueba2020.csv")
# precios2021 <- read.csv("data/prueba2021.csv")
# precios2022 <- read.csv("data/prueba2022.csv")
# precios2023 <- read.csv("data/prueba2023.csv")


precios_total <- rbind(preciosyv2012,
                       preciosyv2013,
                       preciosyv2014,
                       preciosyv2015,
                       preciosyv2016,
                       preciosyv2017,
                       preciosyv2018,
                       preciosyv2019,
                       preciosyv2020,
                       preciosyv2021,
                       preciosyv2022,
                       preciosyv2023)

precios_total <- precios_total %>% 
  filter(provincia == "SANTIAGO DEL ESTERO")
precios2021_SANTIAGO <- preciosyv2022 %>% 
  filter(provincia == "SANTIAGO DEL ESTERO")


precios2021_SANTIAGO$volumen <- round(precios2021_SANTIAGO$volumen, 2)

resultado <- aggregate(precios2021_SANTIAGO$volumen, by = list(precios2021_SANTIAGO$producto), sum)


precios_total <- precios_total %>% 
  rename("año" = "ï..anio")

precios_total$fecha <- as.Date(paste0(sprintf("%02d", precios_total$mes), "/", precios_total$año), format = "%m/%Y")
precios_total$fecha <- as.Date(paste0("01/", sprintf("%02d", precios_total$mes), "/", precios_total$año), format = "%d/%m/%Y")

precios_total$volumen <- ifelse(precios_total$producto == "GNC", precios_total$volumen/1000, precios_total$volumen)

write_xlsx(precios_total, "outputs/precios_volumenes_total_santiago.xlsx")
# #prueba
# preciosyv2012 <- preciosyv2012 %>% 
#   filter(provincia == "SANTIAGO DEL ESTERO")
# 
# precios_total_santiago <- precios_total %>% 
#   filter(provincia == "SANTIAGO DEL ESTERO")
# 
# gnc <- precios2021 %>%
#   filter(provincia == "SANTIAGO DEL ESTERO") %>% 
#   filter(producto == "GNC")
# 
# gasoil <- precios2021 %>%
#   filter(provincia == "SANTIAGO DEL ESTERO") %>% 
#   filter(producto == "Gas Oil Grado 2")
# 
# write.csv(precios_total_santiago, "data/precios_volumenes_santiago_2012_2023.csv")
# 
# estaciones <- st_read("shapefile-de-eess-res-1104-/shapefile-de-eess-res-1104--shp.shp")
# 
# preciosyvolumenes <- st_read("data/precios-y-volumenes-a-partir-de-2018.csv")
# 
# preciosyvolumenes <- st_as_sf(preciosyvolumenes, coords = c("longitud", "latitud"), crs = 4326)
# 
# preciosyvolumenes_santiago <- preciosyvolumenes %>%
#   filter(provincia == "SANTIAGO DEL ESTERO")
# 
# 
# estaciones_santiago <- estaciones %>% 
#   filter(PROVINCIA == "SANTIAGO DEL ESTERO") %>% 
#   mutate(id_estacion = row_number())


precios_volum <- readxl::read_xlsx("data/precios_volum.xlsx")
columnas <- colnames(precios_volum)
#colnames(precios_total)
precios_total$...1 <- "pass"

precios_total <- precios_total %>% 
  rename("anio" = "año")

precios_total_ordenado <- precios_total %>%
  select(!!!columnas)

write_xlsx(precios_total_ordenado, "outputs/precios_volumenes_total_santiago.xlsx")
