library(ggplot2)
View(my_data_spread)

ggplot(data=my_data_spread, aes(x=date))+
    geom_point(aes(y=AnalyzeFMRI), color='red') + 
    geom_point(aes(y=aspect), color='blue') +
    labs(x = "date", y = "count")

summary(data[1])

