library(readr)
library(data.table)
library(pryr)
library(dplyr)
library(ggplot2)
library(ggthemes)

#==============================================================================
#FILE LOADING ####
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

#DATASET: Yellow Taxi Trip Records January-June 2019
#PROFITABILITY OF Yellow Taxi Trip Records

# Overview: How big is the yellow taxi system (estimated 2019).
#   passengers / trips / income

# How profitable is the yellow taxi system?

# Most/less profitable routes
# Range of distances that are more profitable.

# Avg speed by time of the day

# Sensitivity analysis / Equilibrum point

# Simulation??

# Is it worth it to invest in a medallion? Equilibrum point of medallion prices?

#==============================================================================






