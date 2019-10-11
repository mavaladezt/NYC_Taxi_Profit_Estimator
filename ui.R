



#   AGREGAR GRAFICAS POR DAY OF THE WEEK, BOROUGH, HEATMAP WITH DAY OF THE WEEK AND RANGE_HRS

shinyUI(dashboardPage(
    dashboardHeader(title = 'NYC Yellow Taxis'),
    dashboardSidebar(
        sidebarUserPanel("NYC Yellow Taxis"),
        sidebarMenu(
            menuItem("Overview", tabName = "overview", icon = icon("globe")),
            menuItem("Model", tabName = "model",icon = icon("project-diagram")),
            menuItem("Data", tabName = "data", icon = icon("database")),
            menuItem("Assumptions", tabName = "assumptions",icon = icon("project-diagram")),
            menuItem("About", tabName = "about",icon = icon("project-diagram")),
            selectizeInput(inputId = "selected","Select Item to Display",choice)
        )
    ),
    dashboardBody(tabItems(
        tabItem(
            tabName = "overview",
            titlePanel(tags$h4("Estimated 2019")),
            fluidRow(
                infoBoxOutput("sales"),
                infoBoxOutput("nthValue"),
                infoBoxOutput("passengers"),
                infoBoxOutput("contribution"),
                infoBoxOutput("trips"),
                infoBoxOutput("distance"),
                infoBoxOutput("speed"),
                infoBoxOutput("duration")
                
            ),
            
            #                         infoBoxOutput("avgBox")),
            
            # gvisGeoChart
            fluidRow(
                     box(plotOutput("voladora")),
                     # gvisHistoGram
                     box())
        ),
        tabItem(
            tabName = "model",
            titlePanel(tags$h4("FIXED COSTS")),
            fluidRow(
                column(
                    4,
                    sliderInput(
                        "car_price",
                        "Car's Resale & Buy Prices",
                        min = 0,
                        max = 50000,
                        pre = "$",
                        sep = ",",
                        value = c(2000, 25000)
                    )
                ),
                column(
                    4,
                    sliderInput(
                        "car_life",
                        "Car Life:",
                        min = 100000,
                        max = 500000,
                        value = 200000,
                        post = " mi",
                        step = 5000,
                        animate = TRUE
                    )
                ),
                column(
                    4,
                    sliderInput(
                        "insurance",
                        "Insurance (year):",
                        pre = "$",
                        sep = ",",
                        min = 2000,
                        max = 5000,
                        value = 3500
                    )
                )
            ),
            titlePanel(tags$h4("MAINTENANCE COSTS")),
            fluidRow(
                column(
                    4,
                    
                    
                    sliderInput(
                        "tires_breaks",
                        "Tires & Breaks Life:",
                        min = 35000,
                        max = 80000,
                        value = 50000,
                        step = 1000,
                        post = " mi",
                        sep = ",",
                        animate = TRUE
                    ),
                    
                    numericInput("tire_cost", "Tire Set ($)", "500"),
                    numericInput("breaks_cost", "Breaks ($)", "500")
                    
                    
                    
                    
                    
                    
                    
                ),
                column(
                    4,
                    
                    sliderInput(
                        "oil_change",
                        "Oil Change:",
                        min = 2000,
                        max = 10000,
                        value = 5000,
                        step = 500,
                        post = " mi",
                        #pre = "$",
                        sep = ","
                    ),
                    numericInput("oil_cost", "Oil Change ($)", "50")
                    
                ),
                column(
                    4,
                    
                    
                    
                    
                    # Input: Custom currency format for with basic animation ----
                    sliderInput(
                        "other_maintenance",
                        "Other Maintenance:",
                        min = 2000,
                        max = 50000,
                        value = 10000,
                        step = 500,
                        post = " mi",
                        #pre = "$",
                        sep = ","
                    ),
                    
                    numericInput("other", "Other ($)", "150")
                )
                #),
                
                
                
                
            ),
            titlePanel(tags$h4("VARIABLE COSTS")),
            fluidRow(column(4, 
                            
                            sliderInput(
                                "gas",
                                "Gas Price:",
                                min = 2,
                                max = 5,
                                value = 3.5,
                                step = .10,
                                #post = " mi",
                                pre = "$",
                                sep = ","
                            ),sliderInput(
                                "mpg",
                                "Combined mpg:",
                                min = 10,
                                max = 60,
                                value = 20,
                                step = .5,
                                post = " mpg",
                                #pre = "$",
                                sep = ","
                            )
                            
                            
                            
                            ),
                     column(4, sliderInput(
                         "labor",
                         "Labor:",
                         min = 10,
                         max = 40,
                         value = 20,
                         step = 1,
                         post = " /hr",
                         pre = "$",
                         sep = ","
                     )),
                     column(4, 
                            tags$h5("General Settings"),
                            numericInput("miles_year", "Avg Miles per Year:", "40000"),
                            numericInput("avg_speed", "Avg Speed (mph)", "36"),
                            numericInput("time_without_trip", "% Time without trip:", "10")
                            
                            
                            
                            )),
            
            
            
            fluidRow(tableOutput("values"))
        ),
        
        tabItem(tabName = "data",
                # datatable
                fluidRow(box(
                    DT::dataTableOutput("table"), width = 12
                ))),
        tabItem(tabName = "assumptions",
                # datatable
                fluidRow("prueba")
    ),
    tabItem(tabName = "about",
            # datatable
            fluidRow("prueba")
    )
    ))
))
