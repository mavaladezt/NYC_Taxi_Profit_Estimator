model.calculation <- function(n) {n}




shinyServer(function(input, output, session) {


    currentModel <- function() {
        model.calculation(as.numeric(sum(df_overview$amount_fare)+sum(df_overview$amount_extra)-
            (((2*(input$car_price[2]-input$car_price[1])/input$car_life +
                            input$insurance/input$miles_year +
                            (input$tire_cost+input$breaks_cost)/input$tires_breaks +
                            input$oil_cost/input$oil_change +
                            input$other/input$other_maintenance +
                            input$gas/input$mpg +
                            input$labor/input$avg_speed) / (1-(input$time_without_trip/100)))*
                           (sum(df_overview$distance)/sum(df_overview$trips)))*sum(df_overview$trips)
            
                       ))
    }
    
    

    
    
    output$profit <- renderInfoBox({ 
        infoBox('Profit', prettyNum(currentModel(),big.mark=","), icon = icon("chart-line"),color='blue')})
    
    output$profit_perc <- renderInfoBox({ 
        infoBox('Profit', paste(round((currentModel()/(sum(df_overview$amount_fare)+sum(df_overview$amount_extra)))*100,1),"%"), icon = icon("percent"),color='light-blue')})
    
    
    output$profit2 <- renderInfoBox({ 
        infoBox('Profit', prettyNum(currentModel(),big.mark=","), icon = icon("chart-line"),color='blue')})
    
    output$profit_perc2 <- renderInfoBox({ 
        infoBox('Profit', paste(round((currentModel()/(sum(df_overview$amount_fare)+sum(df_overview$amount_extra)))*100,1),"%"), icon = icon("percent"),color='light-blue')})
    
    
    
    output$voladora <- renderPlot(
        ggplot(wat,aes(x=desc,fill=type)) +
            geom_rect(aes(xmin=id-.45,xmax=id+.45,ymin=end,ymax=start)) +
            scale_x_discrete(labels=xlabels) +
            ggtitle("Average NYC Yellow Taxi Trip") +
            theme(plot.title = element_text(hjust=0.5)) + 
            xlab("Revenue Concepts") + ylab("$ per trip (Avg)")
    )


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # Reactive expression to create data frame of all input values ----
    sliderValues <- reactive({
        
        data.frame(
            Name = c("car_price",
                     "car_life",
                     "insurance",
                     "tire_breaks",
                     "tire_cost",
                     "breaks_cost",
                     "oil_change",
                     "oil_cost",
                     "other_maintenance",
                     "other",
                     "gas",
                     "mpg",
                     "labor",
                     "miles_year",
                     "avg_speed",
                     "time_without_trip",
                     "test"
        ),
            Value = as.character(c(paste(input$car_price, collapse =" "),
                                   input$car_life,
                                   input$insurance,
                                   input$tires_breaks,
                                   input$tire_cost,
                                   input$breaks_cost,
                                   input$oil_change,
                                   input$oil_cost,
                                   input$other_maintenance,
                                   input$other,
                                   input$gas,
                                   input$mpg,
                                   input$labor,
                                   input$miles_year,
                                   input$avg_speed,
                                   input$time_without_trip,
                                   (2*(input$car_price[2]-input$car_price[1])/input$car_life +
                                       input$insurance/input$miles_year +
                                       (input$tire_cost+input$breaks_cost)/input$tires_breaks +
                                        input$oil_cost/input$oil_change +
                                       input$other/input$other_maintenance +
                                       input$gas/input$mpg +
                                       input$labor/input$avg_speed) / (1-(input$time_without_trip/100))
                                       
                                   )),
            stringsAsFactors = FALSE)
        
    })
    
    output$tire_cost_value <- renderText({ input$tire_cost })
    
    output$oil_change <- renderText({ input$oil_change })
    
    output$breaks_cost_value <- renderText({ input$breaks_cost })
    
    # Show the values in an HTML table ----
    output$values <- renderTable({
        sliderValues()
    })
    
    
    # show histogram using googleVis
#    output$hist <-
#        renderGvis(gvisHistogram(state_stat[, input$selected, drop =
#                                                FALSE]))
    
    output$table <- DT::renderDataTable({
        datatable(df_data, selection='single',rownames = FALSE,filter="top",options = list(sDom  = '<"top">lrt<"bottom">ip')) %>%
            formatCurrency(columns=c('Fare','Extra',"MTA","Tip","Tolls","Improv.","Total")) %>% 
            formatRound(columns = c("Distance","Avg.Mins","Trips"),digits = 0)  
            #formatStyle(input$selected,
            #            background = "skyblue",
            #            fontWeight = 'bold')
        # Highlight selected column using formatStyle
    })
    output$passengers <- renderInfoBox({
        total_passengers <- round(sum(df_overview$passengers))
        infoBox('Passengers', prettyNum(total_passengers,big.mark=","), icon = icon("users"))
    })
    
    output$sales <- renderInfoBox({
        total_sales <- round(sum(df_overview$amount_total))
        infoBox('Revenue', paste("$",prettyNum(total_sales,big.mark = ",")), icon = icon("money-bill-alt"),color='green')
    })
    
    output$contribution <- renderInfoBox({
        total_contribution <- round(sum(df_overview$amount_mta)+sum(df_overview$amount_tolls)+sum(df_overview$amount_improvement))
        infoBox('Tax: Toll/MTA/Improv.', paste("$",prettyNum(total_contribution,big.mark=",")), icon = icon("hand-holding-usd"),color='olive')
    })
    
    output$distance <- renderInfoBox({
        total_distance <- round(sum(df_overview$distance)/sum(df_overview$trips),2)
        infoBox('Distance (Avg)', paste(prettyNum(total_distance,big.mark=","),"mi"), color='navy')
    })
    
    output$trips <- renderInfoBox({
        total_trips <- round(sum(df_overview$trips))
        infoBox('Trips', prettyNum(total_trips,big.mark=","), icon = icon("shipping-fast"),color='orange')
    })
    
    output$duration <- renderInfoBox({
        total_duration <- round(sum(df_overview$duration)/sum(df_overview$trips))
        infoBox('Duration (Avg)', paste(total_duration,"mins"), icon = icon("hourglass-start"),color='light-blue')
    })
    
    output$speed <- renderInfoBox({
        total_speed <- round((sum(df_overview$distance)/sum(df_overview$trips))/((sum(df_overview$duration)/sum(df_overview$trips))/60),2)
        infoBox('Speed', paste(total_speed,"mph"), icon = icon("tachometer-alt"),color='yellow')
    })
    
    
    
    
    
    
    
    conn2 <- dbConnector(session, dbname = "./taxis.sqlite")

# =============================================================================================
    
    dbGetOrigin_heatmaps <- function(conn) {
        query <- "SELECT DISTINCT (Origen) FROM df_heatmaps"
        as.data.table(dbGetQuery(conn = conn, statement = query))
    }
    
    Origins <<- c("Bronx -",
                  "Manhattan -",
                  "Queens -",
                  "Brooklyn -",
                  "EWR -",
                  "Staten Island -",
                  "Airport",
                  unlist(unique(dbGetOrigin_heatmaps(conn = conn2)),use.names=FALSE)  )
#unlist(myList, use.names=FALSE)
    updateSelectInput(session, inputId = "origin", choices = Origins,
                      selected = 'Manhattan -')
    
    
# =============================================================================================
    
    dbGetData_heatmaps <- function(conn, tblname, o) {
        query <- paste0("SELECT * FROM df_heatmaps WHERE ",
                        "Origen LIKE '%",
                       o,
                       "%'"
                       )
        as.data.table(dbGetQuery(conn = conn, statement = query))
        
        
    }

    observeEvent(input$origin, {
        #temp = df_heatmaps[grepl("Manhattan -",df_heatmaps$Origen),]
        choices = c("Bronx -",
                    "Manhattan -",
                    "Queens -",
                    "Brooklyn -",
                    "EWR -",
                    "Staten Island -",
                    "Airport",
            unique(taxis_db()[grepl(input$origin,taxis_db()$Origen), 
                                    Destino]))
        
        
        updateSelectizeInput(session, inputId = "dest", choices = choices)
        
        
    })    
    
    taxis_db <- reactive(dbGetData_heatmaps(conn = conn2,
                                            tblname = "df_heatmaps",
                                            o = input$origin
                                            )
                         )    
    


        
    output$table2 <- DT::renderDataTable(DT::datatable({
        data <- taxis_db()[grepl(input$dest,taxis_db()$Destino),c(3:7)]
        rownames(data)=NULL
        data
    }))
    
    
    output$demand_heatmap2 <- renderPlot(
        taxis_db()[grepl(input$dest,taxis_db()$Destino),c(3:7)] %>% 
        select(wday,range_hrs,trips) %>% 
            group_by(wday,range_hrs) %>% 
            summarize(trips=sum(trips/365)) %>% 
            ggplot(aes(x = factor(wday), y = factor(range_hrs))) +
            geom_tile(aes(fill = trips)) + scale_fill_gradient(low = "white", high = "black") +
            ggtitle("Average Daily Trips")  + xlab("Day of the Week") + ylab("Hour of the Day") +
            scale_x_discrete(labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))

        
    )
    

    
    output$speed_heatmap2 <- renderPlot(
        taxis_db()[grepl(input$dest,taxis_db()$Destino),c(3:7)] %>% 
            select(wday,range_hrs,distance,duration) %>%
            group_by(wday,range_hrs) %>% 
            summarize(distance=sum(distance),duration=sum(duration)) %>%
            mutate(speed=(distance/(duration/60))) %>%
            select(-distance,-duration) %>%
            ggplot(aes(x = factor(wday), y = factor(range_hrs))) +
            geom_tile(aes(fill = speed)) + scale_fill_gradient(low = "darkred", high = "white") +
            ggtitle("Average Speed (mph)") + xlab("Day of the Week") + ylab("Hour of the Day") +
            scale_x_discrete(labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))
        
    )        
    

    # output$avgBox <- renderInfoBox(infoBox(
    #     paste("AVG.", input$selected),
    #     mean(state_stat[, input$selected]),
    #     icon = icon("calculator"),
    #     fill = TRUE
    # ))
})