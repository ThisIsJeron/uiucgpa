library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(DT)

gpa <- uiuc_gpa_dataset

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("UIUC GPA Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("year",
                    "Year:",
                    c(gpa$Year)),
        
        selectInput("term",
                    "Term:",
                    c(gpa$Term)),
        
        selectInput("subject",
                    "Subject:",
                    c(gpa$Subject))
        
      ),
      
      mainPanel(
         plotlyOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     plot <- filter(gpa, Year = input$year) %>% filter (gpa, Term = input$term) %>% filter(gpa, Subject = input$subject)
   })
}

shinyApp(ui = ui, server = server)