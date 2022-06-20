library(tidyverse)
library(sf)
library(mapview)
library(rvest)
library(httr)



# 3) Read the KML file as a Spatial object
moh_chas_clinics <- read_sf(here::here("chas-clinics-kml.kml"))
setwd('D:/Sioma/mapas/palma_danec/PDE')
moh_chas_clinics <- read_sf("doc.kml")
# Watch data
moh_chas_clinics %>%
        glimpse()


# 4) Get the attributes for each observation

# Option a) Using a simple lapply
attributes <- lapply(X = 1:nrow(moh_chas_clinics), 
                     FUN = function(x) {
                             
                             moh_chas_clinics %>% 
                                     slice(x) %>%
                                     pull(Description) %>%
                                     read_html() %>%
                                     html_node("table") %>%
                                     html_table(header = TRUE, trim = TRUE, dec = ".", fill = TRUE)  
                     })


parcela<-character()
for (i in 1:length(attributes)) {
        parcela[i]<-as.character(attributes[[i]][5,2])
        
}



# 5) Bind the attributes to each observation as new columns

moh_chas_clinics$parcela<-parcela

st_write(moh_chas_clinics, "pde_parcela.shp")

mode(moh_chas_clinics)

mydata2 <- st_collection_extract(moh_chas_clinics, "POLYGON")

mydata3<- filter(mydata2,parcela %in% c("B9a",
                                        "A9d",
                                        "A13d",
                                        "B15c",
                                        "B8a",
                                        "A9d",
                                        "B12b",
                                        "B12a",
                                        "A12d",
                                        "B15a",
                                        "B8d",
                                        "A10d",
                                        "B10a",
                                        "A13d",
                                        "B15c",
                                        "E7c",
                                        "E7d",
                                        "F7a",
                                        "F7b",
                                        "D7a",
                                        "D7b",
                                        "D7c",
                                        "D8c",
                                        "E7a",
                                        "E8a",
                                        "G7b",
                                        "G7a",
                                        "F7d",
                                        "F7c",
                                        "H8b",
                                        "H8c",
                                        "H8d",
                                        "I8a",
                                        "I8b",
                                        "I8c",
                                        "F12b",
                                        "F12c",
                                        "F12d",
                                        "F13b",
                                        "F13c",
                                        "F13d",
                                        "G11a",
                                        "G11b",
                                        "G11c",
                                        "G11d",
                                        "G12a",
                                        "G12b",
                                        "G12c",
                                        "G12d",
                                        "G13a",
                                        "G13b",
                                        "G13c",
                                        "G13d",
                                        "H11a",
                                        "H11b",
                                        "H11c",
                                        "H11d",
                                        "H12a",
                                        "H12b",
                                        "I11a"))

st_write(mydata3, "pde_parcela2.gpkg")
