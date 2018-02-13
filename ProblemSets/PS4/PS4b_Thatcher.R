df1 <- as.data.frame(iris)
df <- createDataFrame(iris)
class(df1)
class(df)
head(select(df, df$Sepal_Length, df$Species))
#this one won't work
head(select(df1, df1$Sepal_Length, df1$Species))
head(filter(df, df$Sepal_Length>5.5))
#this one won't work
head(filter(df1, df1$Sepal_Length>5.5))
head(select(filter(df, df$Sepal_Length>5.5), df$Sepal_Length, df$Species))
head(summarize(groupBy(df, df$Species), mean=mean(df$Sepal_Length), count=n(df$Sepal_Length)))
