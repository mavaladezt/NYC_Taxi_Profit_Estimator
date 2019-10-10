


#   AGREGAR GRAFICAS POR DAY OF THE WEEK, BOROUGH, HEATMAP WITH DAY OF THE WEEK AND RANGE_HRS

shinyUI(dashboardPage(
    dashboardHeader(title = 'NYC Yellow Taxis'),
    dashboardSidebar(
        sidebarUserPanel("NYC Yellow Taxis"),
        sidebarMenu(
            menuItem("Overview", tabName = "overview", icon = icon("globe")),
            menuItem(
                "Model",
                tabName = "model",
                icon = icon("project-diagram")
            ),
            menuItem("Data", tabName = "data", icon = icon("database")),
            selectizeInput(inputId = "selected",
                           "Select Item to Display",
                           choice)
        )
    ),
    dashboardBody(tabItems(
        tabItem(
            tabName = "overview",
            fluidRow(
                infoBoxOutput("sales"),
                infoBoxOutput("passengers"),
                infoBoxOutput("contribution"),
                infoBoxOutput("trips"),
                infoBoxOutput("distance"),
                infoBoxOutput("speed"),
                infoBoxOutput("duration")
            ),
            
            #                         infoBoxOutput("avgBox")),
            
            # gvisGeoChart
            fluidRow(box(htmlOutput("map", height = 300)),
                     # gvisHistoGram
                     box(htmlOutput("hist", height = 300)))
        ),
        tabItem(tabName = "model",
                titlePanel(tags$h4("FIXED COSTS")),
                fluidRow(
                    
                    column(4,sliderInput(
                        "car_price",
                        "Car Price - Resale/Buy",
                        min = 0,
                        max = 50000,
                        pre = "$",
                        sep = ",",
                        value = c(2000, 25000)
                    )),
                    column(4,sliderInput(
                        "car_life",
                        "Car Life:",
                        min = 100000,
                        max = 500000,
                        value = 250000,
                        post = " mi",
                        step = 5000
                    )),
                    column(4,sliderInput(
                        "insurance",
                        "Insurance (year):",
                        pre = "$",
                        sep = ",",
                        min = 800,
                        max = 3000,
                        value = 1500
                    ))
                ),
                fluidRow(
                titlePanel(tags$h4("MAINTENANCE COSTS")),
                
                
                
                column(4,
                       
                       
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
                       
                       textInput("tire_cost", "Tire Set ($)", "500"),
                       textInput("breaks_cost", "Breaks ($)", "500")
                       
                       
                       
                       
                       
                       
                       
                       ),
                column(4,
                       
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
                       textInput("oil_cost", "Oil Change ($)", "50")
                       
                       ),
                column(4,
                       
                       
                       
                       
                           # Input: Custom currency format for with basic animation ----
                           sliderInput(
                               "other",
                               "Other Maintenance:",
                               min = 2000,
                               max = 50000,
                               value = 10000,
                               step = 500,
                               post = " mi",
                               #pre = "$",
                               sep = ","
                           ),
                       
                       textInput("other", "Other ($)", "150"))
                       #),
                       
                       
                       
                       
                       ),titlePanel(tags$h4("VARIABLE COSTS")),
                
                
                
                fluidRow(tableOutput("values"))),
        tabItem(tabName = "data",
                # datatable
                fluidRow(box(
                    DT::dataTableOutput("table"), width = 12
                )))
    ))
))
