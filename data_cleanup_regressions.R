#library(readr)
#library(data.table)
#library(pryr)
#library(dplyr)
#library(lubridate)
#https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page



setwd("/Users/mavt/Dropbox/School/NYCDataScience/Projects/Shiny/")
getwd()


file_in = "yellow_tripdata_2019-06.csv"
file_out = "yellow_tripdata_2019-06_out.csv"
df_locations <- fread("taxi+_zone_lookup.csv")
df_locations$service_zone=NULL

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

#df01=df



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
df=df[df$trip_distance>0,]
df=df[df$duration<150,]

#df = df[df$year==2019,]
#nrow(df)
#df = df[df$month<7,]
#nrow(df)
df = df[df$fare_amount>0,]
nrow(df)


df$range_hrs = ifelse(df$hr>=0 & df$hr<4,'00-04',ifelse(df$hr>=4 & df$hr<8,'04-08',ifelse(df$hr>=8 & df$hr<12,'08-12',ifelse(df$hr>=12 & df$hr<16,'12-16',ifelse(df$hr>=16 & df$hr<20,'16-20','20-24')))))
df$passenger_count=ifelse(df$passenger_count==0,1,df$passenger_count)
df$hr=NULL

a=df[,c(2,6,16)]

a %>% mutate(range_fare=ifelse(fare_amount<5,'00-05',ifelse(fare_amount<10,'05-10',ifelse(fare_amount<15,'10-15',ifelse(fare_amount<20,'15-20',ifelse(fare_amount<25,'20-25','More 25')))))) -> a
a %>% mutate(range_duration=ifelse(duration<5,'00-05',ifelse(duration<10,'05-10',ifelse(duration<15,'10-15',ifelse(duration<20,'15-20',ifelse(duration<25,'20-25','More 25')))))) -> a
a %>% mutate(range_distance=ifelse(trip_distance<5,'00-05',ifelse(trip_distance<10,'05-10',ifelse(trip_distance<15,'10-15',ifelse(trip_distance<20,'15-20',ifelse(trip_distance<25,'20-25','More 25')))))) -> a

a$range_fare=as.factor(a$range_fare)
a$range_duration=as.factor(a$range_duration)
a$range_distance=as.factor(a$range_distance)

fwrite(a,"df_regressions.csv")

a_small = a[sample(1:nrow(df),size = 10000,replace=F),]



(table(a_small$range_fare)/nrow(a_small))*100

nrow(a_small)



#Distancia / Tarifa Promedio
#Distancia / Duración
#Duration / Tarifa Promedio

ggplot(data = a_small, aes(x = trip_distance, y = fare_amount)) +
    geom_point()


ggplot(data = a_small, aes(x = trip_distance, y = duration)) +
    geom_point()

ggplot(data = a_small, aes(x = duration, y = fare_amount)) +
    geom_point()


ggplot(data = a_small, aes(x = trip_distance)) + geom_histogram(binwidth = 0.05)

ggplot(data = a_small, aes(x = fare_amount)) + geom_histogram(binwidth = 1)



hist(a_small$trip_distance,
     main = paste("prueba"),
     col = "#75AADB", border = "white")

