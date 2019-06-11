library(dplyr)
library(ggplot2)

#tägliche Downloadstatistik in Objekt gespeichert
downloads_1day <- read_csv("2019-05-20.csv")

#in Data-frame umformatiert
downloads_1day.frame <- as.data.frame (downloads_1day)

View(downloads_1day.frame)

#listet packages alphabetisch und zählt Anzahl der Nennungen
# = Anzahl tägliche Downloads
count_daily_downloads <- downloads_1day.frame%>%
  arrange(package)%>%
  group_by(package)%>%
  count()

View(count_daily_downloads)

ggplot(data=count_daily_downloads)+
  geom_point(aes(package,n))

#Vor arrange könnte man noch nach psy_packages filtern
#ABER - Warning message:
#In c("rmarkdown", "glue", "pkgconfig", "R6", "Rcpp", "gridExtra",  :
#longer object length is not a multiple of shorter object length

View(psy_packages)

#in Data-frame umformatiert
psy_packages.frame <- as.data.frame (psy_packages)

#Spaltennahme in psy_packages umbenannt
colnames(psy_packages.frame)[colnames(psy_packages.frame)=="V1"] <- "psypackagename"

View(psy_packages.frame)

#psy_packages als Vektor darstellen
psy_vector <- as.vector(psy_packages.frame$psy_packages)

# zeigt Spalte 7 in data an 
packagelist_total <- downloads_1day.frame[,7] 

#View(downloads_1day.frame)

#maximale Anzeige erhöht
options(max.print=999999)

#nach 2 bestimmten packages filtern, die in psychometrics enthalten sind
#702 rows
downloads_1day.frame%>%
  filter(package == c("ade4", "anacor"))

#nach 4 bestimmten packages filtern ,364 rows
downloads_1day.frame%>%
  filter(package == c("ade4", "anacor", "AnalyzeFMRI", "aspect"))
           
#anhand von psychometrics-liste filtern???
downloads_1day.frame%>%
  filter(package == psy_vector)

#überprüfen, ob gelistete packages von psychometrics sind 
#(psy_packages)

#grepl()
