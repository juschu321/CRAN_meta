library(ctv)
library(cranlogs)
install.packages("dplyr")
library(dplyr)
library(tidyr)


# Alle Psychometrics-Pakete
psy_packages <- ctv::available.views()[[30]]$packagelist$name 

#core-packages nicht relevant-> rausgefiltert
psy_packages_nocore <- ctv::available.views()[[30]]$packagelist %>%
  filter(core==FALSE)



View(psy_packages_nocore)


#zeigt Eigenschaften CTV psych
#psy_packages <- ctv::available.views()[[30]] 
View(psy_packages)



cran_downloads()

#cran_top_downloads()

#ctv::available.views

# Alle Download-Statistiken der ausgewählten Pakete seit 01.01.2008
#von cranlogs (cran_downloads)
#Problem, dass es ein dataframe ist und kein AsIs wie psy_packages?
d <-  cran_downloads(
  package = psy_packages_nocore$name, 
  from    = as.Date("2008-01-01"), 
  to      = Sys.Date()-1
)

View(d)

# Export der Daten in eine CSV-Datei
write.csv(d, "mydata.csv", row.names = FALSE)
