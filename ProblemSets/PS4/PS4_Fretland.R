# Erik Fretland
# PS4 R script 1
# 2/12/18
 
install.packages('RCurl')
library(RCurl)
library(jsonlite)

nflstats.json <- getURL("http://api.fantasy.nfl.com/v1/players/stats?statType=seasonStats&season=2010&week=1&format=json")

mydf <- fromJSON(nflstats.json)

class(mydf)
class(mydf$players)

head(mydf$players, n=4)

