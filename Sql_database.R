library(RSQLite)
library(data.table)

setwd("~/Dropbox/School/NYCDataScience/Projects/Shiny/taxis")

csvpath = "./df_heatmaps.csv"
dbname = "./taxis.sqlite"
tblname = "df_heatmaps"
## read csv
data <- fread(input = csvpath,
              sep = ",",
              header = TRUE)
## connect to database
conn <- dbConnect(drv = SQLite(), 
                  dbname = dbname)
## write table
dbWriteTable(conn = conn,
             name = tblname,
             value = data)
## list tables
dbListTables(conn)
## disconnect
dbDisconnect(conn)





setwd("~/Dropbox/School/NYCDataScience/Projects/Shiny/")

csvpath = "./df_regressions.csv"
dbname = "./taxis/taxis.sqlite"
tblname = "df_regressions"
## read csv
data <- fread(input = csvpath,
              sep = ",",
              header = TRUE)
## connect to database
conn <- dbConnect(drv = SQLite(), 
                  dbname = dbname)
## write table
dbWriteTable(conn = conn,
             name = tblname,
             value = data)
## list tables
dbListTables(conn)
## disconnect
dbDisconnect(conn)