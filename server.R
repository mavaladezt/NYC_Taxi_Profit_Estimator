shinyServer(function(input, output) {
    output$map <- renderGvis({
        gvisGeoChart(
            state_stat,
            "state.name",
            input$selected,
            options = list(
                region = "US",
                displayMode = "regions",
                resolution = "provinces",
                width = "auto",
                height = "auto"
            )
        )
        # using width="auto" and height="auto" to
        # automatically adjust the map size
    })
    
    # Reactive expression to create data frame of all input values ----
    sliderValues <- reactive({
        
        data.frame(
            Name = c("Car Price",
                     "Car Life",
                     "Insurance",
                     "Tire/Breaks Life"),
            Value = as.character(c(paste(input$car_price, collapse =" "),
                                   input$car_life,
                                   input$insurance,
                                   input$tires_breaks)),
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
        datatable(state_stat, rownames = FALSE) %>%
            formatStyle(input$selected,
                        background = "skyblue",
                        fontWeight = 'bold')
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
        total_contribution <- round(sum(df_overview[,c(7,9,10)]))
        infoBox('Contribution', paste("$",prettyNum(total_contribution,big.mark=",")), icon = icon("hand-holding-usd"),color='olive')
    })
    
    output$distance <- renderInfoBox({
        total_distance <- round(df_overview$distance/df_overview$trips)
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
        total_speed <- round((df_overview$distance/df_overview$trips)/((df_overview$duration/df_overview$trips)/60))
        infoBox('Speed', paste(total_speed,"mph"), icon = icon("tachometer-alt"),color='yellow')
    })
    

    # output$avgBox <- renderInfoBox(infoBox(
    #     paste("AVG.", input$selected),
    #     mean(state_stat[, input$selected]),
    #     icon = icon("calculator"),
    #     fill = TRUE
    # ))
})