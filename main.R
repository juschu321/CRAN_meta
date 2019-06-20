# all psych packages
psy_packages <- ctv::available.views()[[30]]$packagelist$name

packages_per_ctv <- get_packages_per_ctv()
psy_subcategories <- get_subcategory_of_psy_packages(psy_packages)

# takes a lot of time...
psy_download_statistics <- get_download_statistics(psy_packages)
psy_api_data <- get_api_data(psy_packages)
psy_edgelist <- get_edgelist_of_packages(psy_api_data)

