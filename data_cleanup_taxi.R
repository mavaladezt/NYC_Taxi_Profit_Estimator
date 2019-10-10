#library(readr)
#library(data.table)
#library(pryr)
#library(dplyr)
#library(lubridate)
#https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page

#setwd("/Users/mavt/Documents/Temp/")
#getwd()


#file_in = "yellow_tripdata_2019-06.csv"
#file_out = "yellow_tripdata_2019-06_out.csv"
#df_locations <- fread("taxi+_zone_lookup.csv")
#df_locations$service_zone=NULL

#file_in = "yellow_tripdata_2019-05.csv"
#file_out = "yellow_tripdata_2019-05_out.csv"
#df06=df

#file_in = "yellow_tripdata_2019-04.csv"
#file_out = "yellow_tripdata_2019-04_out.csv"
#df05=df

#file_in = "yellow_tripdata_2019-03.csv"
#file_out = "yellow_tripdata_2019-03_out.csv"
#df04=df

#file_in = "yellow_tripdata_2019-02.csv"
#file_out = "yellow_tripdata_2019-02_out.csv"
#df03=df

#file_in = "yellow_tripdata_2019-01.csv"
#file_out = "yellow_tripdata_2019-01_out.csv"
#df02=df

df01=df



df <- read_csv(file_in, 
            col_types = cols(RatecodeID = col_skip(),
                             VendorID = col_skip(), 
                             store_and_fwd_flag = col_skip(), 
                             congestion_surcharge = col_skip(),
                             tpep_dropoff_datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                             tpep_pickup_datetime = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

df %>% filter(payment_type==1 | payment_type==2 )  -> df

#object_size(df)

df$year=year(df$tpep_pickup_datetime)
df$month=month(df$tpep_pickup_datetime)
df$wday=wday(df$tpep_pickup_datetime)
df$hr=hour(df$tpep_pickup_datetime)
df$duration=difftime(df$tpep_dropoff_datetime,df$tpep_pickup_datetime,units='mins')
df$duration=as.numeric(df$duration)

df$tpep_dropoff_datetime = NULL
df$tpep_pickup_datetime = NULL

df$trips=1

df=df[df$duration>0,]

df = df[df$year==2019,]
#nrow(df)
df = df[df$month<7,]
nrow(df)
df = df[df$fare_amount>0,]
nrow(df)


df$range_hrs = ifelse(df$hr>=0 & df$hr<4,'00-04',ifelse(df$hr>=4 & df$hr<8,'04-08',ifelse(df$hr>=8 & df$hr<12,'08-12',ifelse(df$hr>=12 & df$hr<16,'12-16',ifelse(df$hr>=16 & df$hr<20,'16-20','20-24')))))
df$passenger_count=ifelse(df$passenger_count==0,1,df$passenger_count)
df$hr=NULL

df %>%
    dplyr::rename(LocationID=PULocationID) %>%
    left_join(df_locations,by = "LocationID") %>% 
    dplyr::rename(O_borough=Borough,O_Zone=Zone) %>% 
    select(-LocationID) %>% 
    dplyr::rename(LocationID=DOLocationID) %>%
    left_join(df_locations,by = "LocationID") %>%
    dplyr::rename(D_borough=Borough,D_Zone=Zone) %>%
    select(-LocationID) -> df

fwrite(df,file_out)

df %>% group_by(year,month,O_borough,O_Zone,D_borough,D_Zone,payment_type,wday,range_hrs) %>%
    summarize(passengers=sum(passenger_count),distance=sum(trip_distance),amount_fare=sum(fare_amount),amount_extra=sum(extra),amount_mta=sum(mta_tax),amount_tip=sum(tip_amount),amount_tolls=sum(tolls_amount),amount_improvement=sum(improvement_surcharge),amount_total=sum(total_amount),duration=sum(duration),trips=sum(trips)) -> df


df=rbind(df01,df02,df03,df04,df05,df06)

#unique(df$month)

#nrow(df)

#nrow(df[df$year==2019,])
#nrow(df)

fwrite(df,"trips_2019_01_to_06.csv")

#df_small=df[sample(1:nrow(df),size = 10000,replace=F),]

#object_size(df)
