#library(tidyverse)
#install.packages("tidyverse")
library(httr)
library(jsonlite)

r_api <- function(package) {
  url <- modify_url("http://crandb.r-pkg.org/", path = package)
  
  resp <- GET(url)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"), simplifyVector = FALSE) }

data <- list()
# psy_packages ersetzen durch deine neue fancy Package list 
for (package in psy_packages_nocore$name){
package.api.data <- r_api(package)
#package.api.data$`Authors@R`
data <- c(data, list(package.api.data)) }

View(data)
#Liste mit 198 psychometrics_packages

#zeigt Author der packages
data[[1]][["Author"]]
data[[2]][["Author"]]

#####nach data$Depends/Author filtern, ergibt trotzdem ganze Liste####
for (package in psy_packages_nocore$name){
  package.api.data <- r_api(package)
  package.api.data$Depends
  data_depends <- c(data, list(package.api.data)) }

View(data_depends)

#ergibt nicht viel Sinn, gibt keine Liste nur mit Author aus, sondern tutti
for (package in psy_packages_nocore$name){
  package.api.data <- r_api(package)
  package.api.data$Author
  data_author <- c(data, list(package.api.data)) }

View(data_author)
