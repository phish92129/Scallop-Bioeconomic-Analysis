library(shiny)
library(ggplot2)

df <- data.frame(inputs = c(10, 20),
                 outputs = c(15, 25))


ui <- fluidPage(                                                                #Example UI
  numericInput("input1", "This is input 1:", value = 10, min = 1, max = 20),
  "This is the computed Valiable:",
  textOutput("computed1"),
  "This is the tablular Output:",
  DTOutput("tableOutput"),
  "This is the graphical output",
  plotOutput("graphOutput"),
  actionButton("run_model", "Run Model")
)

server <- function(input, output, session) {
  calcs <- reactiveValues(calculated = NULL) #these represent the variable that will be calc'ed durring
  df <- reactiveValues(df = df)              #these represent the variable that are defined going into it
  
  observe({                                  #This is where calculations occur
    calcs$calculated <- input$input1 * 2
  })
  
  output$computed1 <- renderText({           #This displays calculated vars
  return(paste("calculated number: ", calcs$calculated))
    
  })
    
  output$tableOutput <- renderDT(df$df)      #Table output
  
  output$graphOutput <- renderPlot({         #Plot output
    ggplot(df$df, aes(inputs, outputs))+ geom_point()})
  
  observeEvent(input$run_model, {#Fake running of the model - updates all the thingy
    input1 <- input$input1
    calculated <- calcs$calculated        #this is where we feed back in the primary and secondary params
    
    df$df <- data.frame(inputs = c(input1, calculated), #This is basically where the model gets run with adjusted inputs and outputs 
                                                          #things like output.list and plt.list
                        outputs = c(input1 + 5, calculated +5))
      
      
    })


}

shinyApp(ui, server)