# This script is based on the R-bloggers post at
# http://www.r-bloggers.com/load-postgis-geometries-in-r-without-rgdal/

# Install packages (comment if they are previously installed)
install.packages("RPostgreSQL")
install.packages("rgeos")

# Load packages
library("RPostgreSQL")
library("rgeos")
library("sp")

# Create connection with Postgres db
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,dbname='yourDBname',host='localhost',port=5432,user='yourUser',password='yourPw')
