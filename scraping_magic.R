library(rvest)
library(magrittr)
library(xml2)
library(lubridate)
library(dplyr)

html <- read_html("https://cran.r-project.org/web/views/Psychometrics.html")

# target data frame
package_categories <- data.frame()


# looping over all packages
for (package in psy_packages_nocore$name){
# Get all a (links) with text equal to the current package name
# then select the next higher ul (unordered list)
# then select the p (paragraph) before that ul 
# that p should contain the name of the categoriy
query_string <- paste0("//a[text() = '",package,"'][1]/ancestor::ul/preceding::p[1]")
category <- html %>% html_node(xpath = query_string) %>% html_text(trim = TRUE)

# remove colon of category name
category <- substr(category, 1, nchar(category)-1) 
package_categories <- rbind(package_categories, data.frame(package = package, category = category)) }

