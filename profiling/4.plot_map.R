### Jinliang Yang
### 02-06-2017
### plot map

#Since the maps we’re ultimately interested in generating will show the spatial distribution of Twitter followers in the US, you should eliminate followers that are outside the country.

res1 <- read.delim("data/res1-1000.txt")
res2 <- read.delim("data/res1001-3500.txt")

out <- rbind(res1, res2)

library("ggmap")
library("ggplot2")
library("png")

us <- c(left = -125, bottom = 25.75, right = -67, top = 49)
map <- get_stamenmap(us, zoom = 5, maptype = "toner-lite")


######################################################################################
library(ggmap)
##lowerleftlon, lowerleftlat, upperrightlon, upperrightlat
#  or left/bottom/right/top bounding box
myloc <- c(-150, -50, 0, 80)

mymap <- get_map(location=myloc, source="google", crop=FALSE, color="bw")
ggmap(mymap) + 
    geom_point(aes(x = lng, y = lat), data = out,
               alpha = .2, color="#d2691e", size = 1) 


myloc <- c(-30, -40, 150, 80)

mymap <- get_map(location=myloc, source="google", crop=FALSE, color="bw")
ggmap(mymap) + 
    geom_point(aes(x = lng, y = lat), data = out,
               alpha = .5, color="#d2691e", size = 1) 











install.packages("OpenStreetMap")
library(OpenStreetMap)
library(ggplot2)
map <- openmap(c(70,-179),
               c(-70,179),zoom=1)
map <- openproj(map)






#Let’s quickly check how successful our geocoding and filtering has been so far.
pdf("graphs/fig3.5k.pdf", width=10, height=5)
qmplot(lng, lat, data = out, source="google", maptype = "toner-lite", color = I("red"), alpha = .3)
dev.off()

zoom <- 10
map <- readPNG(sprintf("mapquest-world-%i.png", zoom))
map <- as.raster(apply(map, 2, rgb))

# cut map to what I really need
pxymin <- LonLat2XY (-180,73,zoom+8)$Y # zoom + 8 gives pixels in the big map
pxymax <- LonLat2XY (180,-60,zoom+8)$Y # this may or may not work with google
# zoom values
map <- map [pxymin : pxymax,]

# set bounding box
attr(map, "bb") <- data.frame (ll.lat = XY2LonLat (0, pxymax + 1, zoom+8)$lat, 
                               ll.lon = -180, 
                               ur.lat = round (XY2LonLat (0, pxymin, zoom+8)$lat), 
                               ur.lon = 180)
class(map) <- c("ggmap", "raster")

ggmap (map) + 
    geom_point (data = data.frame (lat = runif (10, min = -60 , max = 73), 
                                   lon = runif (10, min = -180, max = 180)))

qmplot(lng, lat, data=results_e, geom = "blank", zoom = 1, 
       maptype = "toner-background", darken = .7, legend = "topleft") +
    stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
    scale_fill_gradient2("Robbery\nPropensity", low = "white", mid = "yellow", high = "red", midpoint = 650)


american_results<-subset(results_f,
                         grepl(", USA", results_f$Location)==TRUE)
