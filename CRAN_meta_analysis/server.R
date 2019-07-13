library(shiny)
library(shinydashboard)

server <- function(input, output) {
  
 output$plot <- renderPlot(
   {ggplot(data = test2) +
       geom_line( aes (month, total, color = package))+
       scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month",
                    date_labels = "%Y - %m")
     
   })
 }
   

