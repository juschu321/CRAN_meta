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
