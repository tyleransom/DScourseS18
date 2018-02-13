system('wget -O nflstats.json "http://api.fantasy.nfl.com/v1/players/stats?statType=seasonStats&season=2010&week=1&format=json"')
system("cat nflstats.json")
install.packages("jsonlite")
library("jsonlite")
mydf <- fromJSON('nflstats.json')
class(mydf$players)
head(mydf$players)

