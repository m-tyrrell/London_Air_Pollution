library(maps)
mn.map = map(database = "county", region = "minnesota")
mn.map = map("state", "minnesota")

test = map(database = "city", "london")

RgoogleMaps


library(maptools)
minnesota.shp = readShapePoly("minnesota.shp", proj4string=CRS("+proj=longlat"))


library(mapdata)
map("worldHires", "Canada", xlim = c(-141,-53), ylim=c(40,85), col="gray90", fill=TRUE)

library(maps)
sinusoidal.proj = map("world", ylim=c(45,90), xlim=c(-160,-50), col="grey80",fill = TRUE, 
                      plot = FALSE, projection = "mercator")
map(sinusoidal.proj)

coloradoST = read.table("data/colorados-t.dat", header = TRUE)

library(RgoogleMaps)
MyMap = GetMap.bbox(lonR = range(coloradoST$Lon), latR = range(coloradoST$Lat), size=c(640,640), maptype="hyprid")

library(googleway)