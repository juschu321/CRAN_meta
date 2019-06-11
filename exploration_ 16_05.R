library(readr)
library(dtw)
library(tidyr)
library(TSdist)
library(ggfortify)
library(dtwclust)
library(qgraph)

# Daten aus CSV einlesen
mydata <- data.frame(read_csv("mydata.csv", col_types = cols(date = col_date(format = "%Y-%m-%d"))))

# Dataframe umformen: Count pro Package
mydata_spread <- spread(data=mydata, key=package, value=count)

# DTW Test
DTWDistance(mydata_spread$AnalyzeFMRI, mydata_spread$BTLLasso)

# Datum entfernen
mydata_spread_without_date <- (subset(mydata_spread, select = -c(1) ))

# Distance Matrix berechnen
distances <- dist(t(mydata_spread_without_date), method="euclidean", as.dist=TRUE)

# Distance Matrix anzeigen als Netwerk Graph
qgraph(distances, layout='spring', vsize=3)

# PCA Versuch
autoplot(prcomp(t(mydata_spread_without_date)), label=TRUE)



