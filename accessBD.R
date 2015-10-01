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
