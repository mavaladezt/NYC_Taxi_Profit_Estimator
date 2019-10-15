library(shinydashboard)
library(DT)
#library(googleVis)
library(data.table)
library(ggthemes)
library(dplyr)
library(ggplot2)
library(RSQLite)

df_overview <- fread("df_overview.csv")

df_data <- fread("df_data.csv")

#df_heatmaps <- fread("df_heatmaps.csv")

Origins<- c("Bronx -",
            "Manhattan -",
            "Queens -",
            "Brooklyn -",
            "EWR -",
            "Staten Island -",
            "Airport")

#https://wordhtml.com



tot_trips=sum(df_overview$trips)

df_overview %>%
    select(amount_fare,amount_extra,amount_mta,amount_tolls,amount_improvement,amount_tip,amount_total) %>% 
    rename(Fare=amount_fare,Extra=amount_extra,MTA=amount_mta,Tolls=amount_tolls,Improv=amount_improvement,Tip=amount_tip,Total=amount_total) %>% 
    summarize_all(sum) -> x


columns=colnames(x)
x %>% transpose() %>% cbind(columns) -> wat
wat$V1=wat$V1/tot_trips
colnames(wat)=c('Amount','desc')

wat$desc <- as.character(wat$desc)
wat$id <- seq_along(wat$Amount)
wat$type <- ifelse(wat$Amount>0,"in","out")
wat$type[wat$desc=='Total']='net'
#wat$type[wat$desc=='Net']='net'
wat$end <- cumsum(wat$Amount)
wat$end <- c(head(wat$end,-1),0)
wat$start <- c(0,head(wat$end,-1))
wat <- wat[,c(4,3,6,1,5,2)]
wat$type <- as.factor(wat$type)
xlabels=as.character(wat$desc)


#==========================================================



dbConnector <- function(session, dbname) {
    require(RSQLite)
    ## setup connection to database
    conn <- dbConnect(drv = SQLite(), 
                      dbname = dbname)
    ## disconnect database when session ends
    session$onSessionEnded(function() {
        dbDisconnect(conn)
    })
    ## return connection
    conn
}

#dbGetData <- function(conn, tblname, month, day) {
#    query <- paste("SELECT * FROM",
#                   tblname,
#                   "WHERE month =",
#                   as.character(month),
#                   "AND day =",
#                   as.character(day))
#    as.data.table(dbGetQuery(conn = conn,
#                             statement = query))
#}






