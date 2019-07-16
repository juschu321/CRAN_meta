library(shiny)
library(shinydashboard)
library(ggplot2)

server <- function(input, output, session) {
   
   choices <- reactive({
      ctvs_select <- input$ctvs_select
      print (ctvs_select) 
      str(choices)
   })
   
   output$ctvs_select <- renderText({choices})
   
   
   
   output$plot <- renderPlot(
      {ggplot(data = test2) +
            geom_line( aes (month, total, color = package))+
            scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month",
                         date_labels = "%Y - %m")
         
      })
   
   output$value <- renderPrint({ input$checkboxGroup })
   
}
