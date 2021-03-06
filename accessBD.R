# ----------------------------------
# Accesing a PosgGIS database from R
# ----------------------------------

# This script is based on the askubuntu post at
# http://askubuntu.com/questions/312294/once-installed-geos-library-c-and-c-and-then-trying-to-install-rgeos-packa
# and the R-bloggers post at
# http://www.r-bloggers.com/load-postgis-geometries-in-r-without-rgdal/

# The script must be invoked using source("complete path to this script")

# Install packages (comment if they are previously installed)
install.packages("RPostgreSQL")

# Load packages
library("RPostgreSQL")

# Create connection with Postgres DB
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,dbname='yourDBname',host='localhost',port=5432,user='yourUser',password='yourPw')

# Disconnect from the BD
dbDisconnect(con)
dbUnloadDriver(drv)

