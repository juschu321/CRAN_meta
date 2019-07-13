library(shiny)
library(shinydashboard)

body <- dashboardBody(
  fluidRow(
    box(title = "dependencies", "plot dependencies"),
    box(title = "linechart", width = 4, solidHeader = TRUE, status = "primary",
      edgelist[1,1]
    )
    
  ), 
  
  
  fluidRow(
    
    box(
      title = "dependencies", width = 4, solidHeader = TRUE, status = "warning",
      plotOutput("plot")
      
      
      
    )
  )
)

# We'll save it in a variable `ui` so that we can preview it in the console
ui <- dashboardPage(
  dashboardHeader(title = "CRAN"),
  dashboardSidebar(),
  body
)
