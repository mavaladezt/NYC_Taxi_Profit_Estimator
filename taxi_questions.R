library(readr)
library(data.table)
library(pryr)
library(dplyr)
library(ggplot2)
library(ggthemes)

#==============================================================================
#FILE LOADING ####
setwd("/Users/mavt/Documents/Temp/")
getwd()

#df <- fread("trips_2019_01_to_06.csv")

df <- read_csv("trips_2019_01_to_06.csv", 
               col_types = cols(year = col_skip(),
                                month = col_skip(),
                                payment_type= col_skip()))

object_size(df)

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
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) %>% 
    mutate(elapsed_days=ifelse(wday==1,25,26)) -> df

#Daily Dataframe
df %>% mutate(passengers=(passengers/elapsed_days),distance=(distance/elapsed_days),amount_fare=(amount_fare/elapsed_days),amount_extra=(amount_extra/elapsed_days),amount_mta=(amount_mta/elapsed_days),amount_tip=(amount_tip/elapsed_days),amount_tolls=(amount_tolls/elapsed_days),amount_improvement=(amount_improvement/elapsed_days),amount_total=(amount_total/elapsed_days),duration=(duration/elapsed_days),trips=(trips/elapsed_days)) ->
    df_daily
nrow(df_daily)
#object_size(df_daily)

df_daily %>%
    filter(O_Zone=='Upper West Side South',D_Zone=='JFK Airport') %>% 
    group_by(wday,range_hrs) %>% 
    summarize(passengers=sum(passengers),distance=sum(distance),amount_fare=sum(amount_fare),amount_extra=sum(amount_extra),amount_mta=sum(amount_mta),amount_tip=sum(amount_tip),amount_tolls=sum(amount_tolls),amount_improvement=sum(amount_improvement),amount_total=sum(amount_total),duration=sum(duration),trips=sum(trips)) ->
    df_daily_overview

object_size(df_daily_overview)
nrow(df_daily_overview)
fwrite(df_daily_overview,"df_daily_overview.csv")

#==============================================================================

#DATASET: Yellow Taxi Trip Records January-June 2019
#PROFITABILITY OF Yellow Taxi Trip Records

# Overview: How big is the yellow taxi system (estimated 2019).
#   graph by passengers / trips / income
#opt   How much it changed in 10 years?
#opt   May 2011 Uber started

# How profitable is the yellow taxi system? Calculate profits dinamically by route? Average car.
#   How to calculate profitability of a route.
#   Most important factors time/distance of trips, time/distance before getting a trip.

# Does the type of car matters? Calculating profits with different cars.

# Calculate profits by time of the day. Which is the best 10 hr shift if you own a taxi?

# Is it worth it to invest in a medallion? Equilibrum point of medallion prices?

# How many hours before making a profit? Graph for equilibrum point.

# Range of distances that are more profitable.
# Which are the most/less profitable routes?

# Profitability diagram saying which hours are more profitable by hr.

#==============================================================================

#1 Overview: How big is the yellow taxi system (estimated 2019).
#   Create a dashboard with variables: sales, trips, passengers, distance, tolls, duration
#   select daily/monthly/weekly/yearly

Input_time = 'Daily'
Input_variable='Passengers'
multiplier=ifelse(Input_time=='Daily',1,ifelse(Input_time=='Weekly',7,ifelse(Input_time=='Monthly',365/12,365)))

#PASSENGERS
df_daily_overview %>% 
    select(passengers)summarize(passengers=sum(passengers)) -> x

    summarize(passengers=sum(passengers)) %>% 
    ggplot(aes(passengers)) +
    geom_col(aes(y=passengers)) +
#    xlab(c('Mon','Tue','Wed','Thu','Fri','Sat','Sun')) +
    ggtitle("Passengers") +
    theme_economist_white()




