library(shinydashboard)
library(DT)
library(googleVis)
library(data.table)

# convert matrix to dataframe
state_stat <-
    data.frame(state.name = rownames(state.x77), state.x77)
# remove row names
rownames(state_stat) <- NULL
# create variable with colnames as choice
choice <- colnames(state_stat)[-1]

df_overview <- fread("df_overview.csv")

