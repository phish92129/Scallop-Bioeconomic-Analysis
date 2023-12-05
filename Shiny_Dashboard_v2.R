library(shiny)
library(shinydashboard)
library(readxl)
library(readr)
library(DT)
library(shinyjs)
library(dplyr)



# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "BioEconomic Model"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Primary Inputs", tabName = "input1", icon = icon("gears")),
      menuItem("Secondary Inputs", tabName = "input2", icon = icon("sliders")),
      menuItem("Graph Outputs", tabName = "Plots", icon = icon("chart-simple")),
      menuItem("Table Outputs", tabName = "Output", icon = icon("table"))
      )
    ),
#-------------------------------------PRIMARY INPUTS -> UI Only--------------------------------------------------------------------------------------------------------------
###
  dashboardBody(
    tabItems(
      # First tab content (Input1)
      tabItem(
        tabName = "input1",
        fluidPage(
          box(
            title = "Primary Parameters",
            width = 10,
            selectInput("Lease.Type", "Lease Type:",
                        choices = c("Standard Lease", "LPA", "Experimental Lease")),
            
            numericInput("Longline.Quantity", label = tags$div("Long Line Quantity:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Number of Longlines.</i>"))),
                         value = 1, min = 1, max = 20),
            
            numericInput("Longline.Depth", label = tags$div("Long Line Depth:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Lease site depth at low tide.</i>"))),
                         value = 60, min = 1),
            
            numericInput("Longline.SusDepth", label = tags$div("Long Suspended Depth:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Depth of head rope (main line) below surface.</i>"))),
                         value = 15, min = 1),
            
            numericInput("Product", label = tags$div("Product:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Projected Spat.</i>"))),
                         value = 100000, min = 10000),
            
            numericInput("Starting.Year", label = tags$div("Starting Year:"),
                         value = 2024, min = 2023),
            
            numericInput("Consumables", label = tags$div("Consumables:", 
                                                     helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Miscellaneous Annual Gear Ex: gloves, knifes, coffee, rain gear.</i>"))),
                         value = 1000, min = 1),
            
            numericInput("Owner.Salary", label = tags$div("Owner Salary:", 
                                                     helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Projected annual owner salary.</i>"))),
                         value = 35000, min = 1),
            
            numericInput("Insurance", label = tags$div("Insurance Cost:", 
                                                          helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Insurance Costs (Combined).</i>"))),
                         value = 5000, min = 1),
            
            numericInput("Employee.Number", label = tags$div("Full Time Employees:", 
                                                       helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Salaried employees are paid an annual salary and are a fixed operating cost whereas part time employees are a variable cost of labor.</i>"))),
                         value = 1, min = 0),
            
            numericInput("Employee.Salary", label = tags$div("Full Time Employee Salary:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual employee wage per employee.</i>"))),
                         value = 35000, min = 1),
            
            numericInput("Part.Time.Wage", label = tags$div("Part Time Wage:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Minimum is based on federal minimum wage.</i>"))),
                         value = 15, min = 7.5),
            
            selectInput("Harvest.Season", label = tags$div("Harvest Season:", 
                                                           helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Harvest Quarter:<br>Winter: November - January<br>Spring: February - April<br>Summer: May - July<br>Fall: August - October.</i>"))),
                        choices = c('Fall', 'Winter','Spring','Summer')),
            
            selectInput("Harvest.Year", label = tags$div("Harvest Year:", 
                                                           helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Y2: Starts Fall after 2 years<br>Y3: Starts Fall after 3 years<br>Y4: Only Fall after 4 years.</i>"))),
                        choices = c('Y2', 'Y3','Y4')),
            
            selectInput("Spat.Procurement", label = tags$div("Spat Procurement:", 
                                                         helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Two current methods of scallop seed (ie spat):<br>To collect, growers place spat collectors in Y0 Fall and collect in Y0 Spring.  Requires labor and time.<br>The other option is purchase from a third party, more expensive/scallop as scale increases.  Grower would start lease work in Y0 spring with stocking lantern nets with spat at 150-250/tier.</i>"))),
                        choices = c('Wild Spat - Collected', 'Wild Spat - Purchased')),
            
            selectInput("Intermediate.Culture", label = tags$div("Intermediate Culture:", 
                                                             helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Currently the model only supports  lantern net culture the other option is pearl nets.  In this stage growers restock seed in Fall to 25-35/tier.</i>"))),
                        choices = c('Intermediate - Lantern Net')),
            
            selectInput("Grow.Out", label = tags$div("Grow Out Method:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Grow out is the final and potentially longest phase. For lantern net growers would restock to ~10 per tier but in the second year of grow out (3-4 years) they would not need to restock.  Ear hanging requires pinning initially but then only requires cleaning after.</i>"))),
                        choices = c('Ear Hanging', 'Lantern Net')),
            
            
            actionButton("run_model", "Run Model")
          )
        )
      ),
###----------------------Secondary Inputs -> UI Only-----------------------------------------------------------------------------------------------------------
      # Second tab content (Input2)
      tabItem(
        tabName = "input2",
        fluidPage(
          box(
            title = "Wild Spat Collection",
            width = 4,
            numericInput("Wild.Spat.Collector", label = tags$div("Wild Spat Collector:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Predicted number of scallop spat/collector.</i>"))),
                         value = 4000, min = 1),
            numericInput("Spat.Site.Depth", label = tags$div("Spat Site Depth:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Depth of spat collector placement.</i>"))),
                         value = 100, min = 1)
            ),
          
          box(
            title = "Stocking Densities",
            width = 4,
            numericInput("Seed.Net.Density", label = tags$div("Seed Net Density:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 0-1 year old scallops.</i>"))),
                         value = 250, min = 1),
            numericInput("Y1.Stocking.Density", label = tags$div("Y1 Stocking Density:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 1-2 year old scallops.</i>"))),
                         value = 25, min = 1),
            numericInput("Y2.Stocking.Density", label = tags$div("Y2 Stocking Density:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 2-3 year old scallops.</i>"))),
                         value = 10, min = 1),
            numericInput("Y3.Stocking.Density", label = tags$div("Y3 Stocking Density:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 3-4 year old scallops.</i>"))),
                         value = 10, min = 1),
           ),
          
          box(
            title = "Mortality Parameters",
            width = 4,
            numericInput("Y0.Mortality", label = tags$div("Y0 Mortality:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 0-1 year old seed scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y1.Mortality", label = tags$div("Y1 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 1-2 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y2.Mortality", label = tags$div("Y2 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 2-3 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y3.Mortality", label = tags$div("Y3 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 3-4 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            
          ),
          
          box(
            title = "More Parameters",
            width = 4,
            numericInput("Seed.Purchace.Cost", label = tags$div("Seed Purchase Cost:", 
                                                          helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>How much scallop seed costs.  Often sold in batches of price/1000 scallops but that varies so growers will just have to divide.</i>"))),
                         value = 0.01, min = 0, max = 1),
            
            numericInput("Mooring.Length", label = tags$div("Mooring Length:", 
                                                                helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>This is the mooring length as a function of longline suspended depth.  Literature recommends a mooring length of 3-4 times the depth..</i>"))),
                         value = 0.01, min = 4, max = 8),
            
            numericInput("Surface.Float.Spacing", label = tags$div("Surface Float Spacing (feet):", 
                                                                helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>space between surface buoys attached to longline meant for general visibility.</i>"))),
                         value = 100, min = 0),
            
            numericInput("Longline.Spacing", label = tags$div("Longline Spacing:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Margin between longline and lease boundary which will afect total lease area.</i>"))),
                         value = 120, min = 0),
            
            numericInput("Shellfish.License", label = tags$div("Shellfish License Cost:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>All growers require an annual shellfish license that is a fixed operating cost.</i>"))),
                         value = 1200, min = 0),
            
            numericInput("Collectors.Line", label = tags$div("Collectors.Line:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Each anchor line for spat collection has several collectors attached.</i>"))),
                         value = 10, min = 0),
            
            numericInput("Gangion.Length", label = tags$div("Gangion Length:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Gangions or rope lengths used to attach gear such as lantern nets and sub surface buoys to longline.</i>"))),
                         value = 4, min = 0),
            
            numericInput("Daily.Work.Hours", label = tags$div("Daily Work Hours:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Daily work paid for part time help.</i>"))),
                         value = 8, min = 0, max = 24)
            
            ),
          
          box(
            title = "Latern Net Parameters",
            width = 4,
            numericInput("Lantern.Net.Tiers", label = tags$div("Lantern Net Tiers:",
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Standard is 7 or 10 but there can be 20 or more.</i>"))),
                         value = 10, min = 0),
            numericInput("Lantern.Net.Hardball.Spacing", label = tags$div("Lantern Net Hardball Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>hard balls or compression resistant buoys used below the surface to keep gear off the bottom.  .</i>"))),
                         value = 10, min = 0),
            numericInput("Lantern.Net.Anchor.Spacing", label = tags$div("Lantern Net Anchor Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Anchors are placed along longline to keep drift from current to a minimum.</i>"))),
                         value = 25, min = 0),
            numericInput("Lantern.Net.Spacing", label = tags$div("Lantern Net Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Will affect total longline length.</i>"))),
                         value = 3, min = 0),
          ),
          
          box(
            title = "Ear Hanging Parameters",
            width = 4,
            numericInput("Ear.Hanging.Hardball.Spacing", label = tags$div("Ear Hanging Hardball Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Similar to lantern nets but less for dropper lines due to lower surface area.</i>"))),
                         value = 40, min = 0),
            numericInput("Ear.Hanging.Anchor.Spacing", label = tags$div("Ear Hanging Anchor Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Same but for anchors.</i>"))),
                         value = 10, min = 0)
          ),
          
          box(
            title = "Dropper Parameters",
            width = 4,
            numericInput("Dropper.Line.Spacing", label = tags$div("Dropper Line Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Spacing between dropper lines.</i>"))),
                         value = 1, min = 0),
            
            numericInput("Scallops.Per.Dropper", label = tags$div("Scallops Per Dropper:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Total scallops on each dropper line scallops are hung in pairs.</i>"))),
                         value = 140, min = 0),
            
            numericInput("Scallop.Spacing", label = tags$div("Scallop Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Spacing between each scallop couplet.</i>"))),
                         value = 0.5, min = 0),
            
            numericInput("Dropper.Margins", label = tags$div("Dropper Margins:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Margin on either end, growers want a margin near the top to avoid scallops being out of the water when working the line.</i>"))),
                         value = 10, min = 0),
            textOutput("Ear.Hanging.Droppers"),
            textOutput("Dropper.Length")
            
          ),
          
          box(
            title = "Yearly Products:",
            width = 4,
            textOutput("Y1_Product"),
            textOutput("Y2_Product"),
            textOutput("Y3_Product"),
            textOutput("Y4_Product")
          )
        )
      ),

### ----------------------------------Plots Output Tab------------------------------------------------------
      tabItem(
        tabName = "Plots",
        fluidPage(
          box(title = "Labor Costs",
              width = 12,
              plotOutput('LAB')
              ),
          box(title = "Cost of Good Sold",
              width = 12,
              plotOutput('COG')
          ),
          box(title = "Fixed Overhead Costs",
            width = 12,
            plotOutput('FOG')
          )
        )
        ),
### --------------Outputs Pane----------------------------------------------------------------------------------------------      
# Third tab content (Output)
      tabItem(
        tabName = "Output",
        fluidPage(
          box(
            #collapsible = TRUE,
            width = 14,
            headerPanel("Economic Metrics (Abductor)"),
            dataTableOutput("Economic.Metrics.Abductor"),
            headerPanel("Economic Metrics (Whole)"),
            dataTableOutput("Economic.Metrics.Whole") ,
            headerPanel("Cost of Production"),
            dataTableOutput("Cost.Production"),
            headerPanel("Equipment Costs"),
            dataTableOutput("Equipment"),
            headerPanel("Labor"),
            dataTableOutput("Labor"),
            headerPanel("Fuel Cost"),
            dataTableOutput("Fuel"),
            headerPanel("Maintenance Costs"),
            dataTableOutput("Maintenance"),
            headerPanel("Primary Inputs"),
            dataTableOutput("Primary"),
            headerPanel("Secondary Inputs"),
            dataTableOutput("Secondary")
            )
          )
        )
)
)
)


### --------------------------------SERVER--------------------------------------------------------------
# God Help Us
server <- function(input, output) {
### --------Processing Mortality and Dropper Product Calculations----------------------------------------------------------------------------------------
  #Processing Mortality Product Calculations
  Mort.Calcs <- reactive({
    Product_ <- input$Product
    Y0.Mortality_ <- input$Y0.Mortality
    Y1.Mortality_ <- input$Y1.Mortality
    Y2.Mortality_ <- input$Y2.Mortality
    Y3.Mortality_ <- input$Y3.Mortality
    Scallops.Per.Dropper <- input$Scallops.Per.Dropper
    Scallop.Spacing <- input$Scallop.Spacing
    Dropper.Margins <- input$Dropper.Margins
    
    Y1.Product <- Product_ * (1 - Y0.Mortality_)
    Y2.Product <- Y1.Product * (1 - Y1.Mortality_)
    Y3.Product <- Y2.Product * (1 - Y2.Mortality_)
    Y4.Product <- Y3.Product * (1 - Y3.Mortality_)
    Ear.Hanging.Droppers <- ceiling((Y2.Product/Scallops.Per.Dropper))
    Dropper.Length <- ((Scallops.Per.Dropper * Scallop.Spacing)/2 + Dropper.Margins)
    
    return(list(Y1.Product = Y1.Product, Y2.Product = Y2.Product, Y3.Product = Y3.Product, Y4.Product = Y4.Product, Ear.Hanging.Droppers = Ear.Hanging.Droppers, Dropper.Length = Dropper.Length))
  })
  
  # Update the text output when any of the input variables change
  observeEvent(c(input$Product, input$Y0.Mortality, input$Y1.Mortality, input$Y2.Mortality, input$Y3.Mortality, input$Scallops.Per.Dropper, input$Scallop.Spacing, input$Dropper.Margins ), {
    output$Y1_Product <- renderText({
      result <- Mort.Calcs()
      return(paste("Y1.Product: ", round(result$Y1.Product, 0)))
    })
    
    output$Y2_Product <- renderText({
      result <- Mort.Calcs()
      return(paste("Y2.Product: ", round(result$Y2.Product, 0)))
    })
    
    output$Y3_Product <- renderText({
      result <- Mort.Calcs()
      return(paste("Y3.Product: ", round(result$Y3.Product, 0)))
    })
    
    output$Y4_Product <- renderText({
      result <- Mort.Calcs()
      return(paste("Y4.Product: ", round(result$Y4.Product, 0)))
    })
    
    output$Ear.Hanging.Droppers <- renderText({
      result <- Mort.Calcs()
      return(paste("Ear.Hanging.Droppers: ", round(result$Ear.Hanging.Droppers, 0)))
    })
    
    output$Dropper.Length <- renderText({
      result <- Mort.Calcs()
      return(paste("Dropper.Length: ", round(result$Dropper.Length, 0)))
    })
  })
  
  
# ---------Placeholder for Additional stuff----------------------------------------------------------------------------------------------------------------------
  # Placeholder for model execution
  # observeEvent(input$run_model, {
  #   # Replace this with your actual model logic
  #   result <- paste(input$param1, input$param2)
  #   
  #   # Display the output on the second tab
  #   output$output_text <- renderPrint({
  #     print(result)
  #   })
  #   output$output_text2 <- renderPrint({
  #     print(result)
  #   })
  # })
  # 
### -------Rendering Graphical Outputs-----------------------------------------------------------------------------------------------------  
  output$LAB <- renderPlot(plt.List$LAB_plt)
  output$COG <- renderPlot(plt.List$COG_plt)
  output$FOG <- renderPlot(plt.List$FOG_plt)
  
  
  
### -------Rendering table outputs-----------------------------------------------------------------------------------------------------  
  #Making a spreadsheet - for now this doesnt respond to running the moddle as the model isn't implimented
  # Its reading from the Output.List
  
  output$Economic.Metrics.Abductor <- renderDataTable(
  datatable(Output.List$`Economic Metrics (Adductor)`,
            options = list(paging = FALSE,    ## paginate the output
                           scrollX = TRUE,   ## enable scrolling on X axis
                           scrollY = TRUE,   ## enable scrolling on Y axis
                           autoWidth = FALSE, ## use smart column width handling
                           server = FALSE,  ## use client-side processing
                           searching = FALSE,
                           info = FALSE,
                           dom = 'Bfrtip',     ##Bfrtip
                           buttons = c('csv', 'excel'),
                           columnDefs = list(list(targets = "_all", orderable  = FALSE))
            ),
            extensions = 'Buttons',
            selection = 'single', ## enable selection of a single row
            filter = 'none',              ## include column filters at the bottom
            rownames = TRUE, colnames = rep("", ncol(Output.List$`Economic Metrics (Adductor)`))       ## don't show row numbers/names
  ))
  
  output$Economic.Metrics.Whole <- renderDataTable(
    datatable(Output.List$`Economic Metrics (Whole)`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = TRUE,
              colnames = rep("", ncol(Output.List$`Economic Metrics (Whole)`))
    ))
  
  output$Cost.Production <- renderDataTable(
    datatable(Output.List$`Cost of Production`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
              )
    )
  
  output$Equipment <- renderDataTable(
    datatable(Output.List$Equipment,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE      ## don't show row numbers/names
    )
  )
  
  output$Labor <- renderDataTable(
    datatable(Output.List$Labor,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE     ## don't show row numbers/names
    )
  )
  
  output$Fuel <- renderDataTable(
    datatable(Output.List$Fuel,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Maintenance <- renderDataTable(
    datatable(Output.List$Maintenance,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Primary <- renderDataTable(
    datatable(Output.List$`Primary Inputs`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Secondary <- renderDataTable(
    datatable(Output.List$Secondary,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  

}
###-----------Run Application------------------------------------------------------------------------------------------------------
# Run the application
shinyApp(ui, server)


































