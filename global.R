library(ctv)
library(cranlogs)
library(tidyverse)
library(httr)
library(jsonlite)
library(rvest)
library(magrittr)
library(xml2)
library(lubridate)
library(dplyr)
library(ggplot2)
library(scales)

####function get_packages_per_ctv####
# Packages per CTV
# Returns a list of all packages and their ctv name and core specification
get_packages_per_ctv <- function () {
  package_ctv <- data.frame()
  for (view in ctv::available.views()) {
    packagelist <- view[["packagelist"]]
    for (i in 1:dim(packagelist)[1]) {
      core <- (packagelist[["core"]][i])
      name <- (packagelist[["name"]][i])
      package_ctv <-
        rbind(package_ctv,
              data.frame(
                package = name,
                ctv = view$name,
                core = core
              ))
    }
  }
  return(package_ctv)
}

####funtion get_api_data#####
# Takes a string of a package
# Returns a list of the corresponding API-data
r_api <- function(package) {
  url <- modify_url("http://crandb.r-pkg.org/", path = package)
  
  resp <- GET(url)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  parsed <-
    jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"), simplifyVector = FALSE)
}


# Takes a list of package names as strings
# Returns the API data as list
get_api_data <- function (packages) {
  api_data <- list()
  for (package in packages) {
    package.api.data <- r_api(package)
    api_data <- c(api_data, list(package.api.data))
  }
  return(api_data)
}


####function get_edgelist_of_packages(api_data_of_packages)####
# Takes API data as list
# Returns a edgelist of "depends", "imports", "suggests"
get_edgelist_of_packages <- function (api_data_of_packages) {
  edgelist <- data.frame()
  for (package in api_data_of_packages) {
    for (dependency in names(package$Depends)) {
      edgelist <-
        rbind(
          edgelist,
          data.frame(
            this = package$Package,
            needs_this = dependency,
            type = "depends"
          )
        )
    }
    for (import_dependency in names(package$Imports)) {
      edgelist <-
        rbind(
          edgelist,
          data.frame(
            this = package$Package,
            needs_this = import_dependency,
            type = "imports"
          )
        )
    }
    
    for (import_dependency in names(package$Suggests)) {
      edgelist <-
        rbind(
          edgelist,
          data.frame(
            this = package$Package,
            needs_this = import_dependency,
            type = "suggests"
          )
        )
    }
  }
  
  return(edgelist)
}

####function get_subcategory_of_psy_packages####

# takes the list of psy_packages
# returns as list of psy_packagaes with eaxch subcategory
get_subcategory_of_psy_packages <- function(psy_packages) {
  html <-
    read_html("https://cran.r-project.org/web/views/Psychometrics.html")
  
  # target data frame
  psy_package_categories <- data.frame()
  
  
  # looping over all packages
  # "psy_packages" may need to be replaced
  for (package in psy_packages) {
    # Get all a (links) with text equal to the current package name
    # then select the next higher ul (unordered list)
    # then select the p (paragraph) before that ul
    # that p should contain the name of the categoriy
    # XPATH
    query_string <-
      paste0("//a[text() = '",
             package,
             "'][1]/ancestor::ul/preceding::p[1]")
    category <-
      html %>% html_node(xpath = query_string) %>% html_text(trim = TRUE)
    
    # remove colon of category name
    category <- substr(category, 1, nchar(category) - 1)
    
    psy_package_categories <-
      rbind(psy_package_categories,
            data.frame(package = package, category = category))
  }
  
  return (psy_package_categories)
}

#####function get_download_statistics (adapted from 1999)####

# Takes a list of package names as strings
# Returns the download statistics of the given packages since 01.01.1999
get_download_statistics <- function(packages) {
  download_statistics <- data.frame()
  for (package in packages) {
    current_package_stats <- cran_downloads(
      package = package,
      from    = as.Date("1999-01-01"),
      to      = Sys.Date() - 1
    )
    download_statistics <- rbind(download_statistics, current_package_stats)
  }
  return(download_statistics)
}


####function: get global data####
#generate global_data
global_edgelist <- data.frame()
global_api <- list()
global_download <- data.frame ()

#gather global data of all ctvs
for (view in ctv::available.views()) {
  packages <- view$packagelist$name
  download_statistics <- get_download_statistics(packages)
  api_data <- get_api_data(packages)
  global_api <- rbind(global_api, api_data)
  edgelist <- get_edgelist_of_packages(api_data)
  global_edgelist <- rbind(global_edgelist, edgelist)
  global_download <- rbind(global_download, download_statistics)
  print(paste(view$name, "is done."))
}

packages_per_ctv <- get_packages_per_ctv()

tutti_dependencies <-
  inner_join(global_edgelist, packages_per_ctv, by = c ("this" = "package"))

tutti_timeseries <- 
  inner_join(global_download, packages_per_ctv, by = c("package" = "package"))


#####psychometric_specific#####
#psychometrics-specific
psy_packages <- ctv::available.views()[[30]]$packagelist$name
psy_subcategories <- get_subcategory_of_psy_packages(psy_packages)


#####function: filter global data#####
#filter global data
#alles was hier drin steht, ist der default
filter_timeseries_data <-
  function (selected_from = as.Date("1999-01-01"),
            selected_to = Sys.Date() - 1,
            selected_packages = list(),
            selected_min_count = 0,
            selected_ctv = list(),
            level = "ctv") {
    if (level == "package") {
      filtered_data <- tutti_timeseries %>%
        filter (package == selected_packages) %>%
        filter (date >= selected_from, date <= selected_to) %>%
        filter (count >= selected_min_count) %>%
        select (date, count, package)
    }
    else{
      filtered_data <- tutti_timeseries %>%
        filter (ctv == selected_ctv) %>%
        filter (date >= selected_from, date <= selected_to) %>%
        filter (count >= selected_min_count) %>%
        select (date, count, ctv)
    }
    
    return (filtered_data)
  }



####function: aggregation time####
aggregate_timeseries_data <- function (timelevel = "monthly", filtered_data){
  download_monthly <- filtered_data %>%
    mutate(month = as.Date(cut(date, breaks = "month"))) %>%
    group_by_at(vars(-c(date, count))) %>% # group by everything but date, day, count   
    summarise(total = sum(count))
}


#####else#####
test <- filter_timeseries_data(selected_from = "2000-06-02",
                               selected_packages = c("abc","aspect"),
                               selected_min_count= 50, level = "package")

test2 <- aggregate_timeseries_data(filtered_data = test)


ggplot(data = test2) +
  geom_line( aes (month, total, color = package))+
  scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month",
               date_labels = "%Y - %m")





