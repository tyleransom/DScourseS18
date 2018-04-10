#Erik Fretland
# PS4 R Script 2
# 2/12/18

install.packages('dplyr')
library(dplyr)
install.packages('sparkR')
library(sparkR)

df1 <- as.data.frame(iris)

sparkR.session()

df <- createDataFrame(iris)

class(df)

class(df1)

head(select(df, df$Sepal.Length, df$Species))

head(select(df1, Sepal.Length, Species))

# The code for the previous command did not work because it was unnecessary to
# include the dataframe name (df1) and the operator before the two column
# names. The select function recognizes that the columns listed are part of
# the dataframe mentioned at the start of the parentheses.

head(filter(df, df$Sepal.Length > 5.5))

head(filter(df1, Sepal.Length > 5.5))

# Again, the code for the previous command did not work because R recognizes
# that the column listed is part of the previously mentioned dataframe.

head(select(filter(df1, Sepal.Length > 5.5), Sepal.Length, Species))

head(summarize(group_by(df1, Species), mean=mean(df1$Sepal.Length), count=n(df1$Species)))

# df2 output

df2 <- createDataFrame(df1)

install.packages('gtools')
library(gtools)

head(arrange(df2, asc(df2$Species)))




