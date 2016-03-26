# -----------------------------------
# Map creation with R+Leaflet
# -----------------------------------

# This script is based on the following posts:
# http://amsantac.co/blog/es/r/2015/08/11/leaflet-R-es.html
# http://trendct.org/2015/06/26/tutorial-how-to-put-dots-on-a-leaflet-map-with-r/
# http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/
# http://www.r-bloggers.com/the-leaflet-package-for-online-mapping-in-r/
# and those included in https://github.com/WeekendArchaeo/R/blob/master/accessBD.R

# Data obtained from the Open Data Website of the Málaga Townhall
# http://datosabiertos.malaga.eu/dataset/malaga-citysense-mayo-2015


# Packages are loaded
library("leaflet")
library("RPostgreSQL")


# Database connection
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,dbname='YOUR_DB',host='localhost',port=5432,user='YOUR_USER',password='YOUR_PASSWD')


# Data retrieving
movistar <- dbGetQuery(con,"SELECT device_model, app_version, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE operator LIKE '%ovistar'")
vodafone <- dbGetQuery(con,"SELECT device_model, app_version, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE operator LIKE '%odafone ES'")
yoigo <- dbGetQuery(con,"SELECT device_model, app_version, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE operator LIKE '%oigo'")
orange <- dbGetQuery(con,"SELECT device_model, app_version, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE operator LIKE '%range'")
lowbattery <- dbGetQuery(con,"SELECT battery_level, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE battery_level <= 50")
batteryOK <- dbGetQuery(con,"SELECT battery_level, ST_X(ST_Transform(coordinatesxy,4326)),ST_Y(ST_Transform(coordinatesxy,4326)) FROM may2015 WHERE battery_level > 50")

# Map creation
m <- leaflet() %>% setView(lng = -4.5, lat = 36.7, zoom = 11) %>%
     addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
     addProviderTiles("Esri.WorldTopoMap", group = "ESRI Topography") %>%
     addProviderTiles("Esri.WorldImagery", group = "ESRI Imagery") %>%
     addLayersControl(baseGroups = c("OpenStreetMap", "ESRI Topography", "ESRI Imagery"),overlayGroups = c("Movistar","Vodafone","Yoigo","Orange","Low Battery","Battery OK"),options = layersControlOptions(collapsed = FALSE)) %>%
     addLegend(position = 'topright', colors = c("blue","red","magenta","orange","yellow","green"), labels = c( c("Movistar","Vodafone","Yoigo","Orange","Low Battery (<50)","Battery OK (>=50)")), opacity = 0.4,title = 'Data Retrieved from DB')


# Adding data to map
for (i in 1:nrow(movistar))
{
  m <- addCircleMarkers(m, lng=movistar$st_x[i], lat=movistar$st_y[i], radius = 5, color = "blue",
                        popup=paste("DEVICE MODEL: ",movistar$device_model[i]," APP: ",movistar$app_version[i]), 
                        group="Movistar")
}

for (i in 1:nrow(vodafone))
{
  m <- addCircleMarkers(m, lng=vodafone$st_x[i], lat=vodafone$st_y[i], radius = 5, color = "red",
                        popup=paste("DEVICE MODEL: ",vodafone$device_model[i]," APP: ",vodafone$app_version[i]),
                        group="Vodafone")
}

for (i in 1:nrow(yoigo))
{
  m <- addCircleMarkers(m, lng=yoigo$st_x[i], lat=yoigo$st_y[i], radius = 5, color = "magenta",
                  popup=paste("DEVICE MODEL: ",yoigo$device_model[i]," APP: ",yoigo$app_version[i]), 
                  group="Yoigo")
}

for (i in 1:nrow(orange))
{
  m <- addCircleMarkers(m, lng=orange$st_x[i], lat=orange$st_y[i], radius = 5, color = "orange",
                  popup=paste("DEVICE MODEL: ",orange$device_model[i]," APP: ",orange$app_version[i]), 
                  group="Orange")
}

for (i in 1:nrow(lowbattery))
{
  m <- addCircleMarkers(m, lng=lowbattery$st_x[i], lat=lowbattery$st_y[i], radius = 5, color = "yellow",
                  popup=paste("BATTERY LEVEL: ",lowbattery$battery_level[i]), 
                  group="Low Battery")
}

for (i in 1:nrow(batteryOK))
{
  m <- addCircleMarkers(m, lng=batteryOK$st_x[i], lat=batteryOK$st_y[i], radius = 5, color = "green",
                  popup=paste("BATTERY LEVEL: ",batteryOK$battery_level[i]), 
                  group="Battery OK")
}


# Disconnect from the BD
dbDisconnect(con)
dbUnloadDriver(drv)
