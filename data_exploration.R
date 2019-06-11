library(readr)
install.packages("tidyr")
library(tidyr)
library(cranlogs)
library(dplyr)
library(ggplot2)
read.csv("mydata.csv")

my_data <- read_csv("mydata.csv")

#Datum formatieren
my_data <- read_csv("mydata.csv", col_types = cols(date = col_date(format = "%Y-%m-%d")))
View(my_data)

#check the data structure
str(my_data)

#my_data zu data_frame umgewandelt
data_frame <- as.data.frame(my_data)
my_data_spread <- tidyr::spread(data=my_data, key = package, value = count)

View(my_data_spread)

ggplot(data=my_data_spread, aes(x=date))+
    geom_point(aes(y=AnalyzeFMRI), color='red') + 
    geom_point(aes(y=aspect), color='blue') +
    labs(x = "date", y = "count")


plot(x = my_data_spread$date, y = my_data_spread$AnalyzeFMRI, type = "l")

?plot

#ade4a <- my_data_spread%>%
  #select(date,ade4)

#visualization of the distribution of package ade4
#ggplot (data = ade4a)+
#  geom_point(aes(date,ade4a), position = "identity",
#            pch =21, fill = "steelblue", alpha = 1/4, size = 2)+
#  labs(title = "Distribution of downloads of the package ade4", 
#      x = "date", y = "count")


#visualization of two different packages
#ggplot (data = my_data_spread, aes (x = date))+
#  geom_line(aes(y=ade4), color='red') + 
#  geom_line(aes(y=betareg), color='blue') +
#  labs(x = "date", y = "count")
  


