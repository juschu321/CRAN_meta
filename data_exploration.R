library(readr)
install.packages("tidyr")
library(tidyr)
library(cranlogs)
library(dplyr)
library(ggplot2)
read.csv("mydata.csv")


#Datum formatieren
my_data <- read_csv("mydata.csv", col_types = cols(date = col_date(format = "%Y-%m-%d")))
View(my_data)

#check the data structure
str(my_data)

#my_data zu data_frame umgewandelt
data_frame <- as.data.frame(my_data)
my_data_spread <- tidyr::spread(data=my_data, key = package, value = count)

View(my_data_spread)

#Tage zu Monate aggregiert 
monthly <- 
  my_data %>%
  mutate(day = format( date, "%d"), month = format(date, "%m"), 
         year = format(date, "%Y")) %>%
  group_by(year, month, package) %>%
  summarise(total = sum(count))

monthly_df <-as.data.frame(monthly)
monthly_spread <- tidyr::spread(monthly_df, key = package, value = total)

####ggplot playground####
ggplot(data=my_data_spread, aes(x=date))+
    geom_point(aes(y=AnalyzeFMRI), color='red') + 
    geom_point(aes(y=aspect), color='blue') +
    labs(x = "date", y = "count")

ggplot(data=my_data_spread, aes(x=date))+
  geom_point(aes(y=AnalyzeFMRI), color='green', size= 2) + 
  geom_point(aes(y=aspect), color = 'blue',size = 2)+
  geom_point(aes(y=asymmetry), color = 'red', size = 2)+
  labs(x= "date", y = "count")

View(my_data)
ggplot(data = my_data, mapping = aes(x = count, y = package)) +
  geom_point(alpha = 0.1, color = "blue")+ 
  labs(x= "count", y = "package")

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
  


