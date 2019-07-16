library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {
   aggreggated_timeseries_data <- reactive({
      selected_ctvs <- input$ctvs_select
      selected_packages <- input$packages_select
      date_slider <- input$year
      selected_from <- input$year[1]
      selected_to <- input$year[2]
      
      filtered_data <-
         filter_timeseries_data(
            selected_from = selected_from,
            selected_to = selected_to,
            selected_packages = selected_packages,
            selected_ctv = selected_ctvs
         )
      
      aggregated_data <- aggregate_timeseries_data(filtered_data = filtered_data)
      aggregated_data
   })
   
   selected_ctvs <- reactive({
      selected_ctvs <- input$ctvs_select
      selected_ctvs
   })
   
   output$ctvs_select <- renderText({
      selected_ctvs()
   })
   
   
   
   output$plot <- renderPlot({
      data = aggreggated_timeseries_data()
      ggplot(data) +
         geom_line(aes (month, total, color= data$ctv)) +
         scale_x_date(
            date_breaks = "1 year",
            date_minor_breaks = "1 month",
            date_labels = "%Y - %m"
         )
      
   })
   
   output$value <- renderPrint({
      input$checkboxGroup
   })
   
}

