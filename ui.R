




#   AGREGAR GRAFICAS POR DAY OF THE WEEK, BOROUGH, HEATMAP WITH DAY OF THE WEEK AND RANGE_HRS

shinyUI(dashboardPage(skin = "black",
    dashboardHeader(title = 'NYC Yellow Taxis'),
    dashboardSidebar(
        sidebarUserPanel("NYC Yellow Taxis"),
        sidebarMenu(
            menuItem("Overview", tabName = "overview", icon = icon("globe")),
#            menuItem("Model", tabName = "model",icon = icon("project-diagram")),
            menuItem("Trips/Speed Heatmaps",tabName = "heatmaps",icon = icon("stream")),
            menuItem("Profit per Route", tabName = "data", icon = icon("database")),
            menuItem("Usage Distribution", tabName = "distribution", icon = icon("chart-bar")),
            menuItem("Assumptions", tabName = "assumptions", icon = icon("list")),
            menuItem("Model", tabName = "model",icon = icon("project-diagram")),
            menuItem("About", tabName = "about", icon = icon("address-card"))
        )
    ),
    dashboardBody(tabItems(
        tabItem(
# Tab: Overview####
            tabName = "overview",
            titlePanel(HTML("<h2>Estimated 2019</h2>")),
    
fluidRow(               

                
                infoBoxOutput("sales"),
                infoBoxOutput("profit"),
                infoBoxOutput("profit_perc"),
                infoBoxOutput("passengers"),
                infoBoxOutput("contribution"),
                infoBoxOutput("trips"),
                infoBoxOutput("distance"),
                infoBoxOutput("speed"),
                infoBoxOutput("duration")
                
            ),
fluidRow(box(
    
    HTML("
         
         <p>Revenue = Fare + Extra + MTA + Tolls + Improv + Tip</p>
<p>Profit = Fare + Extra - Operating Costs (Model)</p>
<p>Tax: Tolls + MTA + Improvement</p>
         
         
         
         "))
    
    
    
),
            
            #                         infoBoxOutput("avgBox")),
            
            # gvisGeoChart
            fluidRow(box(plotOutput("voladora")))
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
                        step = 2000,
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
                        value = 3500,
                        step=350,
                        animate = TRUE
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
                        max = 100000,
                        value = 50000,
                        step = 5000,
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
                        sep = ",",
                        animate = TRUE
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
                        step = 1000,
                        post = " mi",
                        #pre = "$",
                        sep = ",",
                        animate = TRUE
                    ),
                    
                    numericInput("other", "Other ($)", "150")
                )
                #),
                
                
                
                
            ),
            titlePanel(tags$h4("VARIABLE COSTS")),
            fluidRow(
                column(
                    4,
                    
                    sliderInput(
                        "gas",
                        "Gas Price:",
                        min = 2,
                        max = 5,
                        value = 3.5,
                        step = .35,
                        #post = " mi",
                        pre = "$",
                        sep = ",",
                        animate = TRUE
                    ),
                    sliderInput(
                        "mpg",
                        "Combined mpg:",
                        min = 10,
                        max = 60,
                        value = 20,
                        step = 2,
                        post = " mpg",
                        #pre = "$",
                        sep = ",",
                        animate = TRUE
                    )
                    
                    
                    
                ),
                column(
                    4,
                    sliderInput(
                        "labor",
                        "Labor:",
                        min = 10,
                        max = 40,
                        value = 20,
                        step = 2,
                        post = " /hr",
                        pre = "$",
                        sep = ",",
                        animate = TRUE
                    )
                ),
                column(
                    4,
                    tags$h5("General Settings"),
                    numericInput("miles_year", "Avg Miles per Year:", "70000"),
                    numericInput("avg_speed", "Avg Speed (mph)", "12.56"),
                    numericInput("time_without_trip", "% Time without trip:", "39")
                    
                    
                    
                ),fluidRow(column(12,infoBoxOutput("profit2"),
                           infoBoxOutput("profit_perc2")))
            )
 
# Calculations for Troubleshooting####                   


#            ,
#            fluidRow(tableOutput("values"))
        
),
        
        
        
        
        
        
        
        
        

        tabItem(tabName = "data",
                # datatable
                fluidRow(column(12,
                                
                                HTML("<h2>Profit per Route</h2>"))
                    ,
                    DT::dataTableOutput("table")
                )),
        
    



















tabItem(tabName = "distribution",
        fluidRow(column(12,HTML("<h2>Basic Usage Information</h2>"))),
        # datatable
        fluidRow(box(
            
            radioButtons("dist", "Variable:",
                         c("Distance" = "dist",
                           "Fare" = "fare",
                           "Duration" = "duration"))
            
        )
        
        ),fluidRow(
            
            box(
                
                tabsetPanel(type = "tabs",
                            tabPanel("Plot", plotOutput("plot")),
                            tabPanel("Summary", verbatimTextOutput("summary")),
                            tabPanel("Proportion Table", verbatimTextOutput("proptable"))
                            
                            
                )
            )
        )),












        
        
        tabItem(tabName = "assumptions",
                # datatable
                fluidRow(column(
                    6,
                    
                    HTML(
                        "

<h2>Data Assumptions</h1>
<h4>&nbsp;</h4>
<ul>
<li>
<h4>Working with 2019 data (Jan-Jun).</h4>
</li>
<li>
<h4>Filtered transactions that had duration of more than 2 hrs.</h4>
</li>
<li>
<h4>Filtered trips with 'zero' fare.</h4>
</li>
<li>
<h4>Filtered transactions that were not paid by Credit Card or Cash.</h4>
</li>
<li>
<h4>If driver didn't captured number of passengers I assumed there was only 1 passenger.</h4>
</li>
</ul>





                                    "
                        
                        
                        
                    )
                ),
                column(
                    6,
                    HTML(
                        "


                                    <h2>Model Assumptions</h1>
<h4>&nbsp;</h4>
<ul>
<li>
<h4>Profit is an estimation of total profit that 'stays' in the Taxi business. For example, tips paid, even though are kep by driver, they stay in the Taxi 'system'.</h4>
</li>
<li>
<h4>Estimated profit excludes tolls, MTA&nbsp;and improvement fees since the Taxi company transfers its to the State or City.</h4>
</li>
<li>
<h4>There is a replacement of the net car cost (purchase price - estimated resale value) so that the Taxi company is able to renew cars.</h4>
</li>
</ul>





                                    "
                        
                        
                    )
                ))),
        tabItem(tabName = "about",
                # datatable
                fluidRow(column(
                             6,
                             
                             
                             HTML(
                                 "


                                 <h1>Mario Valadez Trevino</h1>
<h4>&nbsp;</h4>
<h4>Mario Valadez Trevino is a NYC Data Science Fellow with a B.S. in Industrial Engineering with minor in Systems Engineering and an MBA.</h4>
<h4>Mario has relevant experience in demand forecasting, production and transportation planning, warehouse management systems and supply chain network design optimization and simulation. Also with experience in the food industry as a business owner.</h4>
<a href='https://www.linkedin.com/in/mavaladezt/'>LinkedIN</a>
<p></p>
<a href='https://github.com/mavaladezt/'>github</a>







                                 "
                             )
                             
                         )))
        
        ,
        tabItem(tabName = "heatmaps",
                fluidRow(column(12,HTML("<h2>Usage vs Speed</h2>"))),
                # datatable
                fluidRow(box(plotOutput("demand_heatmap2")),
                         box(plotOutput("speed_heatmap2")
                             
                             
                             
                             )
                         ),fluidRow(column(12,
                                           
                                           selectizeInput(inputId = "origin", 
                                                          label = "Origin",
                                                          choices = Origins,
                                                          selected = "Manhattan -"),
                                           selectizeInput(inputId = "dest", 
                                                          label = "Destination",
                                                          choices = NULL))))
    ))
))
