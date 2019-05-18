
library(rgeos)
library(rgdal)
library(sp)
library(dplyr)
library(ggplot2)


library(reshape2)

importdata <- function(dirs) {
        all <- NULL
        ### Variables to keep
        ls = dir(file.path("data","crime"))
        for(i in ls){
                t = read.csv(file.path("data","crime",i))
                all = rbind(all, t)
        }
        return(all)
}



test1 = function(type){
        switch(type, mean = 1, median = 2, trimmed = 3)
}

test1(2)


dir("data/crime")

test <- importdata("data/crime")

crimes = test %>%
        select(Month, Longitude, Latitude, LSOA.code, LSOA.name, Crime.type)


crimeTypes <- dcast(crimes, LSOA.name ~ Crime.type, value.var = "Crime.type")
colnames(crimeTypes) <- c("LSOA_name", "anti_social_behaviour", "bicycle_theft", "burglary",
                          "criminal_damage_and_arson", "drugs", "other_crime", "other_theft",
                          "possession_of_weapons", "public_order", "robbery", "shoplifting",
                          "theft_from_the_person", "vehicle_crime", "violence_and_sexual_offences")

crimesNoArea <- crimes[, c("Month", "Longitude", "Latitude", "Crime.type")]



emmissions = read.csv("data/Emission Sources.csv")
pollution = read.csv("data/Pollution Health and Sociodemographic data.csv")


file.path("data/London_Sport")

ldn1 = readOGR(dsn = "data/LSOA Geographies - shapefile", layer = "LSOA Geographies")
proj4string(ldn1) <- CRS("+init=epsg:27700")
ldn1.wgs84 <- spTransform(ldn1, CRS("+init=epsg:4326"))

ldn2 = readOGR(dsn = "data/LSOA Geographies.shp", layer = )


map1 <- ggplot(ldn1.wgs84) +
        geom_polygon(aes(x = long, y = lat, group = group), fill = "white", colour = "black")
map1 + labs(x = "Longitude", y = "Latitude", title = "Map of Southwark/Lambeth LSOA")



map1 + geom_point(data = crimesNoArea, aes(x = Longitude, y = Latitude, colour = Crime.type)) + 
        scale_colour_manual(values = rainbow(14)) + 
        labs(x = "Longitude", y = "Latitude", title = "Map of Southwark/Lambeth LSOA")


test = emmissions %>%
        select(LSOA11CD, NOx.Emissions.tpa)


map1 + geom_point(data = test, aes(x = Longitude, y = Latitude), colour = "red") + 
        labs(title = "Bicycle theft in Greater London - December 2016")


