library(readr)
library(data.table)
library(pryr)
library(dplyr)
library(ggplot2)
library(ggthemes)

#setwd("/Users/mavt/Documents/Temp/")
#getwd()

#file_out = "yellow_tripdata_2019-06_out.csv"
#file_out = "yellow_tripdata_2019-05_out.csv"
#file_out = "yellow_tripdata_2019-04_out.csv"
#file_out = "yellow_tripdata_2019-03_out.csv"
#file_out = "yellow_tripdata_2019-02_out.csv"
#file_out = "yellow_tripdata_2019-01_out.csv"


df <- fread("yellow_tripdata_2019-01_out.csv")
df$trips=1
#object_size(df)

#Average transit time to airports en rango horas 0-4am,4-8,8-12,12-4pm,4-8.8-12 
df$range_hrs = ifelse(df$hr>=0 & df$hr<4,'00-04',ifelse(df$hr>=4 & df$hr<8,'04-08',ifelse(df$hr>=8 & df$hr<12,'08-12',ifelse(df$hr>=12 & df$hr<16,'12-16',ifelse(df$hr>=16 & df$hr<20,'16-20','20-24')))))
df$passenger_count=ifelse(df$passenger_count==0,1,df$passenger_count)
df$hr=NULL

#df$O_borough=as.factor(df$O_borough)
#df$O_Zone=as.factor(df$O_Zone)
#df$O_borough=as.factor(df$O_borough)
#df$D_Zone=as.factor(df$D_Zone)
#df$payment_type=as.factor(df$payment_type)
#df$wday=as.factor(df$wday)
#df$hr=as.factor(df$hr)

df %>% group_by(year,month,O_borough,O_Zone,D_borough,D_Zone,payment_type,wday,range_hrs) %>%
    summarize(passengers=sum(passenger_count),distance=sum(trip_distance),amount_fare=sum(fare_amount),amount_extra=sum(extra),amount_mta=sum(mta_tax),amount_tip=sum(tip_amount),amount_tolls=sum(tolls_amount),amount_improvement=sum(improvement_surcharge),amount_total=sum(total_amount),amount_congestion=sum(congestion_surcharge),duration=sum(duration),trips=sum(trips)) -> df
object_size(df)
#nrow(df)
#sum(df$trips)
#===========================================================================
df06=df
df05=df
df04=df
df03=df
df02=df
df01=df

df=rbind(df01,df02,df03,df04,df05,df06)
unique(df$month)
nrow(df)
#df = df[df$month<7,]
#nrow(df[df$year==2019,])
#nrow(df)
fwrite(df,"trips_2019_01_to_06.csv")
#===========================================================================

df_small=df[sample(1:nrow(df),size = 2000,replace=F),]
fwrite(df_small,"df_small.csv")

#==============================================================================

# 5 Best time to arrive/depart NYC Airports.
    # Graph of day/hours with trips and time

#1=Monday
#L-V: 4     S-D: 5

bind_rows(
    df %>% 
        filter(grepl("Airport", O_Zone, fixed = F)) %>%
        group_by(O_Zone,wday,range_hrs) %>% 
        summarize(passengers=sum(passengers),trips=sum(trips)) %>% 
        mutate(orientation='out',trips=-trips) %>% 
        rename(Airport=O_Zone),
    df %>% 
        filter(grepl("Airport", D_Zone, fixed = F)) %>%
        group_by(D_Zone,wday,range_hrs) %>% 
        summarize(passengers=sum(passengers),trips=sum(trips)) %>% 
        mutate(orientation='in') %>% 
        rename(Airport=D_Zone)) -> airport

airport %>% mutate(day_normalizer=ifelse(wday>=6,5,4)) -> airport

nrow(airport)
object_size(airport)
fwrite(airport,"airport.csv")

#VIEW1
#create a table with arrivals and departures by airport per day and range hrs (0-4am,4-8,8-12,12-4pm,4-8.8-12)
#with trips i can see if there is shortage of taxis

#FILTERS 1
#input_airport='Newark Airport'
#input_airport='JFK Airport'
#input_airport='LaGuardia Airport'
input_airport='All Airport'

#FILTER 2
input_trip=F

#ifelse(input_airport %in% airport$Airport,input_airport,'Airport')

airport %>% filter(grepl(ifelse(input_airport %in% airport$Airport,input_airport,'Airport'), Airport, fixed = F)) %>% 
    ggplot(aes(range_hrs,ifelse(input_trip=T,trips,passengers)/day_normalizer)) +
    geom_col(aes(fill=orientation),position='dodge')
g














#VIEW2
#Average transit time to airports en rango horas 0-4am,4-8,8-12,12-4pm,4-8.8-12 









airport %>% 
    filter(grepl("Airport", D_Zone, fixed = F)) -> d_airport
d_airport$O_borough=NULL
object_size(d_airport)
nrow(d_airport)
fwrite(d_airport,"d_airport.csv")






o_airport %>% filter(O_Zone=='Lincoln Square East',D_Zone=='Newark Airport')

#make a graph with amount of trips and average duration
#maybe a graph with amount of passengers and and average duration

#second graph with average price which should be a fixed value






airport = df[grepl("Airport",df$O_Zone) | grepl("Airport",df$D_Zone),]
airport = airport[!is.na(airport$O_Zone),]
airport = airport[!is.na(airport$D_Zone),]
airport %>% group_by(O_borough,O_Zone,D_borough,D_Zone,wday,hr) %>%
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),amount_congestion=sum(amount_congestion),duration=sum(duration),trips=sum(trips)) -> airport
nrow(airport)
object_size(airport)

fwrite(airport,"airport.csv")

#==============================================================================

#DATASET: Yellow Taxi Trip Records for June 2019
#PROFITABILITY OF Yellow Taxi Trip Records

# Overview: How big is the yellow taxi system (latest year).
# How much it changed in 10 years?
    # May 2011 Uber started

# How profitable is the yellow taxi system? Calculate profits dinamically by route? Average car.
    # How to calculate profitability of a route.
    # Most important factors time/distance of trips, time/distance before getting a trip.

# Does the type of car matters? Calculating profits with different cars.

# Calculate profits by time of the day. Which is the best 10 hr shift if you own a taxi?

# Is it worth it to invest in a medallion? Equilibrum point of medallion prices?

# How many hours before making a profit? Graph for equilibrum point.

# Range of distances that are more profitable.
    # Which are the most/less profitable routes?

#==============================================================================

#STEPS
#1. Process last 12 months and make a big database.
#2. Process June-2019 database for examples.
#