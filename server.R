fib <- function(n) {n*2.01}


shinyServer(function(input, output) {
    
    currentFib <- function() {
        fib(as.numeric(input$car_life))
    }
    
    output$nthValue <- renderInfoBox({ 
        infoBox('nthValue', prettyNum(currentFib(),big.mark=","), icon = icon("chart-line"),color='blue')})
    
    
    output$voladora <- renderPlot(

        
        ggplot(wat,aes(x=desc,fill=type)) +
            geom_rect(aes(xmin=id-.45,xmax=id+.45,ymin=end,ymax=start)) +
            scale_x_discrete(labels=xlabels) +
            ggtitle("Average NYC Yellow Taxi Trip") +
            theme(plot.title = element_text(hjust=0.5))
    )
    
    
#    output$demand_heatmap <- renderPlot(
#        
#        df_overview[complete.cases(df_overview),] %>%
#            select(wday,range_hrs,trips) %>% 
#            mutate(trips=(trips/365)) %>% 
#            ggplot(aes(x = wday, y = range_hrs)) +
#            geom_tile(aes(fill = trips)) + scale_fill_gradient(low = "white", high = "black")
#        
#    )
#    
#    output$speed_heatmap <- renderPlot(
#        
#        df_overview[complete.cases(df_overview),] %>%
#            select(wday,range_hrs,distance,duration) %>% 
#            mutate(speed=(distance/(duration/60))) %>% 
#            select(-distance,-duration) %>%     
#            ggplot(aes(x = wday, y = range_hrs)) +
#            geom_tile(aes(fill = speed)) + scale_fill_gradient(low = "darkred", high = "white")
#    
#    )    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
    output$hist <-
        renderGvis(gvisHistogram(state_stat[, input$selected, drop =
                                                FALSE]))
    
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
        infoBox('Sales', paste("$",prettyNum(total_sales,big.mark = ",")), icon = icon("money-bill-alt"),color='green')
    })
    
    output$contribution <- renderInfoBox({
        total_contribution <- round(sum(df_overview$amount_mta)+sum(df_overview$amount_tolls)+sum(df_overview$amount_improvement))
        infoBox('Tax Contribution', paste("$",prettyNum(total_contribution,big.mark=",")), icon = icon("hand-holding-usd"),color='olive')
    })
    
    output$distance <- renderInfoBox({
        total_distance <- round(df_overview$distance/df_overview$trips,2)
        infoBox('Distance (Avg)', paste(prettyNum(total_distance,big.mark=","),"mi"), color='navy')
    })
    
    output$trips <- renderInfoBox({
        total_trips <- round(sum(df_overview$trips))
        infoBox('Trips', prettyNum(total_trips,big.mark=","), icon = icon("shipping-fast"),color='orange')
    })
    
    output$duration <- renderInfoBox({
        total_duration <- round(df_overview$duration/df_overview$trips)
        infoBox('Duration (Avg)', paste(total_duration,"mins"), icon = icon("hourglass-start"),color='light-blue')
    })
    
    output$speed <- renderInfoBox({
        total_speed <- round((df_overview$distance/df_overview$trips)/((df_overview$duration/df_overview$trips)/60),2)
        infoBox('Speed', paste(total_speed,"mph"), icon = icon("tachometer-alt"),color='yellow')
    })
    

    # output$avgBox <- renderInfoBox(infoBox(
    #     paste("AVG.", input$selected),
    #     mean(state_stat[, input$selected]),
    #     icon = icon("calculator"),
    #     fill = TRUE
    # ))
})