#load the libraries needed
library(datasets)
library(ggplot2)

#get the data, in this case Iris
data(iris)

#get a quick summary to know what we are looking at
summary(iris)

#just do a simple plot in order to get a look at the data
#color by species - setosa=6633FF (blueish), versicolor=660033 (deep magenta), virginica=CCCCFF (light blue/purple)
plot(iris, 
     pch = 23, 
     bg=c("#6633FF", "#660033", "#CCCCFF")
     [unclass(iris$Species)],
     main = "Basic Plot")

#scatter plot to see the relationship between petal length and petal width
plot(iris$Petal.Length, iris$Petal.Width, 
     pch=23,
     bg=c("#6633FF", "#660033", "#CCCCFF") 
     [unclass(iris$Species)], 
     main = "Petals", 
     xlab = "Petal Length", 
     ylab = "Petal Width")

#look at the linear relationship between petal length and petal width
abline(lsfit(iris$Petal.Length, iris$Petal.Width))

#now scatter plot for the relationship between speal length and width
plot(iris$Sepal.Length, iris$Sepal.Width, 
     pch=23,
     bg=c("#6633FF", "#660033", "#CCCCFF") 
     [unclass(iris$Species)], 
     main = "Sepals", 
     xlab = "Sepal Length", 
     ylab = "Sepal Width")

#look at the linear relationship between the speal length and width
abline(lsfit(iris$Sepal.Length, iris$Sepal.Width))






