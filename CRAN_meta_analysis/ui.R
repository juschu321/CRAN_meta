library(shiny)
library(shinydashboard)
library(ggplot2)

body <- dashboardBody(
  
  fluidRow(
  box(title = "filter", width = 8, solidHeader = TRUE, status = "primary",
      selectInput("ctv", "CTV: a plot can contain multiple ctvs",
                                       c("All")),
      textInput("package", "Package: you can select multiple packages"),
      selectInput("core", "Core: you can either choose between FALSE and TRUE",
                  c("FALSE","TRUE")),
      selectInput("subcategory", "Psychometrics: you can specify on subcategories",
                  c("All")
  ))),
  
  
  
  fluidRow(
    box(title = "plot: dependencies",width = 4, solidHeader = TRUE, status = "primary", "plot dependencies"),
    box(title = "plot: linechart", width = 4, solidHeader = TRUE, status = "primary",
        plotOutput("plot") 
    )
    
  ),
  
  
  fluidRow(
     
      box( title = "dependencies", width = 4, solidHeader = TRUE, status = "primary",
        checkboxGroupInput(
          "checkGroup",
          label = "specify type of dependencies",
          choices = list(
            "imports" = 1,
            "depends" = 2,
            "suggests" = 3
          ),
          selected = 0
        )
      ),
      
    box(title = "date range", width = 4, solidHeader = TRUE, status = "primary",
    dateRangeInput('dateRange2',
                   label = paste ('select a time span'),
                   min = as.Date("1999-01-01"), max = Sys.Date() - 1,
                   separator = " - ", format = "dd/mm/yy",
                   startview = 'year', language = 'en', weekstart = 1
    )
  )
  
  
  
  ),
  
  fluidRow(
    box(title = "date range", width = 4, solidHeader = TRUE, status = "primary",
        sliderInput("year", "time span", 1999, 2019, value = c(1999, 2019),
                    sep = "")
        )
  ))
    
    
    
  


# We'll save it in a variable `ui` so that we can preview it in the console
ui <- dashboardPage(
  dashboardHeader(title = "CRAN"),
  dashboardSidebar(collapsed= TRUE),
  body
)
