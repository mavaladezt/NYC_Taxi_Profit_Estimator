library(readr)
library(data.table)
library(pryr)
library(dplyr)
library(ggplot2)
library(ggthemes)

#==============================================================================
#DF_OVERVIEW ####
setwd("/Users/mavt/Dropbox/School/NYCDataScience/Projects/Shiny/taxis/")
getwd()

#df <- fread("trips_2019_01_to_06.csv")

multiplier=365/181

df <- read_csv("trips_2019_01_to_06.csv", 
               col_types = cols(year = col_skip(),
                                month = col_skip(),
                                payment_type= col_skip()))

df %>% 
    group_by(O_borough,O_Zone,D_borough,D_Zone) %>% 
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) ->
    df_total

df_total %>% mutate(passengers=(passengers*multiplier),distance=(distance*multiplier),amount_fare=(amount_fare*multiplier),amount_extra=(amount_extra*multiplier),amount_mta=(amount_mta*multiplier),amount_tip=(amount_tip*multiplier),amount_tolls=(amount_tolls*multiplier),amount_improvement=(amount_improvement*multiplier),amount_total=(amount_total*multiplier),duration=(duration*multiplier),trips=(trips*multiplier)) ->
    df_total

object_size(df_total)

#Mon	25  51
#Tue	26  52
#Wed	26  52
#Thu	26  52
#Fri	26  52
#Sat	26  52
#Sun	26  51

#==============================================================================
#FILE PROCESSING ####

df_small = df[sample(1:nrow(df),size = 10000,replace=F),]

#General Dataframe
df %>% 
    group_by(O_borough,O_Zone,D_borough,D_Zone,wday,range_hrs) %>% 
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) ->
    df
#%>% mutate(elapsed_days=ifelse(wday==1,25,26)) -> df

#Daily Dataframe


df %>% mutate(passengers=(passengers*multiplier),distance=(distance*multiplier),amount_fare=(amount_fare*multiplier),amount_extra=(amount_extra*multiplier),amount_mta=(amount_mta*multiplier),amount_tip=(amount_tip*multiplier),amount_tolls=(amount_tolls*multiplier),amount_improvement=(amount_improvement*multiplier),amount_total=(amount_total*multiplier),duration=(duration*multiplier),trips=(trips*multiplier)) ->
    df_summary
#nrow(df_daily)
#object_size(df_daily)

df_summary %>%
#    filter(O_Zone=='Upper West Side South',D_Zone=='JFK Airport') %>% 
    group_by(wday,range_hrs) %>% 
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) ->
    df_overview

#object_size(df_daily_overview)
#nrow(df_daily_overview)
fwrite(df_overview,"df_overview.csv")

#==============================================================================

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
wat$end <- cumsum(wat$Amount)
wat$end <- c(head(wat$end,-1),0)
wat$start <- c(0,head(wat$end,-1))
wat <- wat[,c(4,3,6,1,5,2)]
wat$type <- as.factor(wat$type)
xlabels=as.character(wat$desc)

voladora <- ggplot(wat,aes(x=desc,fill=type)) +
    geom_rect(aes(xmin=id-.45,xmax=id+.45,ymin=end,ymax=start)) +
    scale_x_discrete(labels=xlabels) +
    ggtitle("Average NYC Yellow Taxi Trip") +
    theme(plot.title = element_text(hjust=0.5)) 
voladora

str(voladora)

#ggplot(data = wat,aes(x =wat$Desc)) + geom_bar(aes(fill =type))

#==============================================================================



#==============================================================================
#DF_DATA ####
setwd("/Users/mavt/Dropbox/School/NYCDataScience/Projects/Shiny/taxis/")
getwd()

#df <- fread("trips_2019_01_to_06.csv")

multiplier=365/181
multiplier=1/181

df <- read_csv("trips_2019_01_to_06.csv", 
               col_types = cols(year = col_skip(),
                                month = col_skip(),
                                payment_type= col_skip()))

df %>% 
    group_by(O_borough,O_Zone,D_borough,D_Zone) %>% 
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) %>% 
    mutate(passengers=(passengers*multiplier),distance=(distance*multiplier),amount_fare=(amount_fare*multiplier),amount_extra=(amount_extra*multiplier),amount_mta=(amount_mta*multiplier),amount_tip=(amount_tip*multiplier),amount_tolls=(amount_tolls*multiplier),amount_improvement=(amount_improvement*multiplier),amount_total=(amount_total*multiplier),duration=(duration*multiplier),trips=(trips*multiplier)) %>% 
    mutate(passengers=(passengers/trips),distance=(distance/trips),amount_fare=(amount_fare/trips),amount_extra=(amount_extra/trips),amount_mta=(amount_mta/trips),amount_tip=(amount_tip/trips),amount_tolls=(amount_tolls/trips),amount_improvement=(amount_improvement/trips),amount_total=(amount_total/trips),duration=(duration/trips)) %>% 
    filter(O_borough!="Unknown" & D_borough!="Unknown" & O_Zone!="NV" & D_Zone!="NV") %>% 
    rename('From Borough'=O_borough,Zone=O_Zone,'To Borough'=D_borough,"To Zone"=D_Zone,"Daily Passengers"=passengers,Distance=distance,Fare=amount_fare,Extra=amount_extra,MTA=amount_mta,Tip=amount_tip,Tolls=amount_tolls,Improv.=amount_improvement,Total=amount_total,"Avg.Mins"=duration,Trips=trips) %>% 
    select(-"Daily Passengers") %>% 
    arrange(-Trips) ->
    df_data

object_size(df_data)

fwrite(df_data,"df_data.csv")


#==============================================================================
# HEATMAPS ####
df_overview[complete.cases(df_overview),] %>%
    select(wday,range_hrs,trips) %>% 
    mutate(trips=(trips/365)) %>% 
    ggplot(aes(x = wday, y = range_hrs)) +
    geom_tile(aes(fill = trips)) + scale_fill_gradient(low = "white", high = "black")

df_overview[complete.cases(df_overview),] %>%
    select(wday,range_hrs,distance,duration) %>% 
    mutate(speed=(distance/(duration/60))) %>% 
    select(-distance,-duration) %>%     
    ggplot(aes(x = wday, y = range_hrs)) +
    geom_tile(aes(fill = speed)) + scale_fill_gradient(low = "darkred", high = "white")


#==============================================================================
#FILE PROCESSING ####

#General Dataframe
df[complete.cases(df),c(1:6,8,16,17)] %>% 
    filter(O_borough!="Unknown" & D_borough!="Unknown" & O_Zone!="NV" & D_Zone!="NV") %>%
    mutate(Origen=paste0(O_borough," - ",O_Zone),Destino=paste0(D_borough," - ",D_Zone)) %>%
    select(-O_borough,-O_Zone,-D_borough,-D_Zone) %>% 
    group_by(Origen,Destino,wday,range_hrs) %>% 
    summarize(distance=sum(distance),duration=sum(duration),trips=sum(trips)) ->
    df_heatmaps

object_size(df_heatmaps)
nrow(df_heatmaps)
fwrite(df_heatmaps,"df_heatmaps.csv")


#==============================================================================

library(RSQLite)
library(data.table)

setwd("/Users/mavt/Dropbox/School/NYCDataScience/Projects/Shiny/taxis/")
getwd()

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



#==============================================================================
