install.packages('here')
library("here")
install.packages('tidyverse')
library('dplyr')
install.packages("sf")
library("sf")
install.packages("tmap")
library('tmap')

here::here()

#reading in spatial data 

WorldMapRaw <- st_read(here::here("hw_wk4_data",
                                   "World_Countries_(Generalized).geojson"))

#reading in UNDP data 

UNDPRaw <- read.csv(here::here("hw_wk4_data",
                               "HDR23-24_Composite_indices_complete_time_series.csv"),
                    header = TRUE, 
                    sep = ",",  
                    encoding = "latin1")

#cleaning up data 

giiData <- UNDPRaw %>%
  dplyr::select(c(2),
                contains('gii'))

#only need gii_2010-2019: 

gii2010_19 <- giiData %>%
  dplyr::select(c(1,23,32))

#creating column with difference: 

giidifference <- gii2010_19 %>%
  mutate(giidiff = gii_2010 - gii_2019)

giimapdata <- giidifference %>%
  dplyr::select(c(1,4))

#cleaning World Map before merge

WorldMap1 <- WorldMapRaw %>%
  rename_with(tolower)

WorldMap2 <- WorldMap1 %>%
  dplyr::select(c(2,6))

#data merge

giidiffMap<- WorldMap2 %>% 
  left_join(., 
            giimapdata,
            by = "country")

#data plot 

tmap_mode("plot")
qtm(giidiffMap, 
    fill = "giidiff") 

tmap_mode("plot") 

#with legend:

tm_shape(giidiffMap) +
  tm_fill("giidiff", title = "Difference in inequality between 2010 and 2019") +
  tm_borders("grey", lwd = 0.1) +
  tm_layout(legend.title.size = 0.6)







