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
                    distinct(gpa, Year)),
        
        selectInput("term",
                    "Term:",
                    distinct(gpa, Term)),
        
        selectInput("subject",
                    "Subject:",
                    distinct(gpa, Subject)),
        
        uiOutput("course")
        
      ),
      
      mainPanel(
         plotlyOutput("distPlot")
      )
   )
)

server <- function(input, output) {
  
   output$course <- renderUI({
     course <- filter(gpa, Year == input$year)
     course <- filter (course, Term == input$term) 
     course <- filter(course, Subject == input$subject)
     selectInput("course",
                 "Course Number:",
                 distinct(course, Number))
   })
   output$distPlot <- renderPlotly({
     plot <- filter(gpa, Year == input$year)
     plot <- filter (plot, Term == input$term) 
     plot <- filter(plot, Subject == input$subject)
     plot <- filter(plot, Number == input$course)
     plot <- data.frame(
       letter = c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"),
       number = c(plot$"A+", plot$"A", plot$"A-", plot$"B+", plot$"B", plot$"B-", plot$"C+", plot$"C", plot$"C-", plot$"D+", plot$"D", plot$"D-", plot$"F")
     )
     plot <- ggplot(data = plot, aes(x = letter, y = number)) + geom_bar(stat = "identity")
   })
}

shinyApp(ui = ui, server = server)