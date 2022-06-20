library(tidyverse)
library(sf)
library(mapview)
library(rvest)
library(httr)

# 1) Download the kml file
moh_chas_clinics <- GET("https://data.gov.sg/dataset/31e92629-980d-4672-af33-cec147c18102/download",
                        write_disk(here::here("moh_chas_clinics.zip"), overwrite = TRUE))

# 2) Unzip the downloaded zip file 
unzip(here::here("moh_chas_clinics.zip"))

# 3) Read the KML file as a Spatial object
moh_chas_clinics <- read_sf(here::here("chas-clinics-kml.kml"))

# Watch data
moh_chas_clinics %>%
        glimpse()

# See map
mapview(moh_chas_clinics)

# 4) Get the attributes for each observation

# Option a) Using a simple lapply
attributes <- lapply(X = 1:nrow(moh_chas_clinics), 
                     FUN = function(x) {
                             
                             moh_chas_clinics %>% 
                                     slice(x) %>%
                                     pull(Description) %>%
                                     read_html() %>%
                                     html_node("table") %>%
                                     html_table(header = TRUE, trim = TRUE, dec = ".", fill = TRUE) %>%
                                     as_tibble(.name_repair = ~ make.names(c("Attribute", "Value"))) %>% 
                                     pivot_wider(names_from = Attribute, values_from = Value)
                             
                     })

# Option b) Using a Parallel lapply (faster)
future::plan("multisession")

attributes <- future.apply::future_lapply(X = 1:nrow(moh_chas_clinics), 
                                          FUN = function(x) {
                                                  
                                                  moh_chas_clinics %>% 
                                                          slice(x) %>%
                                                          pull(Description) %>%
                                                          read_html() %>%
                                                          html_node("table") %>%
                                                          html_table(header = TRUE, trim = TRUE, dec = ".", fill = TRUE) %>%
                                                          as_tibble(.name_repair = ~ make.names(c("Attribute", "Value"))) %>% 
                                                          pivot_wider(names_from = Attribute, values_from = Value)
                                                  
                                          })

# 5) Bind the attributes to each observation as new columns
moh_chas_clinics_attr <- 
        moh_chas_clinics %>%
        bind_cols(bind_rows(attributes)) %>%
        select(-Description)

# Watch new data
moh_chas_clinics_attr %>%
        glimpse()

# New map
mapview(moh_chas_clinics_attr, 
        zcol = "CLINIC_PROGRAMME_CODE", 
        layer.name = "Clinic Programme Code")