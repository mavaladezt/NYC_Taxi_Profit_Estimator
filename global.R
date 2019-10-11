library(shinydashboard)
library(DT)
library(googleVis)
library(data.table)
library(ggthemes)

# convert matrix to dataframe
state_stat <-
    data.frame(state.name = rownames(state.x77), state.x77)
# remove row names
rownames(state_stat) <- NULL
# create variable with colnames as choice
choice <- colnames(state_stat)[-1]

df_overview <- fread("df_overview.csv")



tot_trips=sum(df_overview$trips)

df_overview %>%
    select(amount_fare,amount_extra,amount_mta,amount_tolls,amount_improvement,amount_tip,amount_total) %>% 
    rename(Fare=amount_fare,Extra=amount_extra,MTA=amount_mta,Tolls=amount_tolls,Improv=amount_improvement,Tip=amount_tip,Total=amount_total) %>% 
    summarize_all(sum) -> x
#x["Net"]=sum(x)-sum(x$MTA)-sum(x$Tolls)-sum(x$Improv)

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




