

library("ctv")
available.views()

#And in fact the object returned by available.views() has all the information about package names:
  
  a <- ctv::available.views()

  
  View(a)
a[[30]]$packagelist$name

#Because at first this may seem a little bit opaque:
  
  ## position 30 can be computed as
  nam <- sapply(a, "[[", "name")
nam
which(nam == "Psychometrics")

## so the Psychometrics view is
a[[30]]

## the package list is
a[[30]]$packagelist

## which contains
a[[30]]$packagelist$name

a <- ctv::available.views()[[30]]$packagelist$name
