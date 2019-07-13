# all psych packages
library(cranlogs)
library(ctv)
library(dplyr)
library(ggplot2)
library(scales)

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


#psychometrics-specific
psy_packages <- ctv::available.views()[[30]]$packagelist$name
psy_subcategories <- get_subcategory_of_psy_packages(psy_packages)


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


aggregate_timeseries_data <- function (timelevel = "monthly", filtered_data){
  download_monthly <- filtered_data %>%
    mutate(month = as.Date(cut(date, breaks = "month"))) %>%
    group_by_at(vars(-c(date, count))) %>% # group by everything but date, day, count   
    summarise(total = sum(count))
}



test <- filter_timeseries_data(selected_from = "2000-06-02",
                         selected_packages = c("abc","aspect"),
                         selected_min_count= 50, level = "package")

test2 <- aggregate_timeseries_data(filtered_data = test)


ggplot(data = test2) +
  geom_line( aes (month, total, color = package))+
       scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month",
       date_labels = "%Y - %m")



