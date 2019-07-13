# all psych packages
library(cranlogs)
library(ctv)
library(dplyr)

global_edgelist <- data.frame()
global_api <- data.frame()
global_download <- data.frame ()


for (view in ctv::available.views()){
  #packages <- view$packagelist$name
  download_statistics <-get_download_statistics(packages)
  #api_data <- get_api_data(packages)
  #global_api <- rbind(global_api, api_data)
  #edgelist <- get_edgelist_of_packages(api_data)
  #global_edgelist <- rbind(global_edgelist, edgelist)
}

View(api_data)


packages_per_ctv <- get_packages_per_ctv()

tutti_edgelist <- inner_join(global_edgelist, packages_per_ctv, by = c ("this" = "package"))



psy_packages <- ctv::available.views()[[i]]$packagelist$name

psy_subcategories <- get_subcategory_of_psy_packages(psy_packages)

# takes a lot of time...
psy_download_statistics <- get_download_statistics(psy_packages)
psy_api_data <- get_api_data(psy_packages)
psy_edgelist <- get_edgelist_of_packages(psy_api_data)

#to get monthly download statistics
psy_spread_monthly <- data.frame()
psy_spread_monthly <- 
  psy_download_statistics %>%
  mutate(day = format(date, "%d"), month = format(date, "%m"), 
         year = format(date, "%Y")) %>%
  group_by(year, month, package) %>%
  summarise(total = sum(count))

psy_spread_monthly <- tidyr::spread(psy_spread_monthly, key = package, value = total)
