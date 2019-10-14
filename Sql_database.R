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