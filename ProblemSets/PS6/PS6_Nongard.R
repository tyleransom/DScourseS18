#Alex Nongard
#PS6
#R Script cleaning / visualizing solar radiation data for OK mesonet sites


solar<-read.csv("solar.csv")
head(solar)
#there are 5k+ daily entries for each of the 98 mesonet sites, with daily insolation shown in Joules per square meter
solarmean<-apply(solar,2,mean)
solarmean<-solarmean[-1]
head(solarmean)
#this gives us the average solar power for each site over the thirteen years
mesonet$solarmean<-solarmean #adding it into the mesonet station table for ease and comfort
mesonet$s2 <- mesonet$solarmean / 100000 #making life easier later
plot(mesonet$s2, main="Mean Solar Value (100,000 J) of Each Site in Oklahoma", xlab="Sites in Oklahoma", ylab="Solar Mean (J)")
#This plot shows the overall distribution of mean solar values in Oklahoma. Doesn't look like a very strong correlation...


#Cook's D outlier test
lmsun<-lm(s2~1,mesonet)
cooksd.1 <- cooks.distance(lmsun)

plot(cooksd.1, pch="*", cex=1, main="Outliers' Influence by Cook's distance")  
abline(h = 4*mean(cooksd.1, na.rm=T), col="red") 
text(x=1:length(cooksd.1)+1, y=cooksd.1, labels=ifelse(cooksd.1>4*mean(cooksd.1, na.rm=T),
                                                       names(cooksd.1),""),
     col="red", cex = .6)

# Here we use Cooks D observations with cooksd > 4 times the mean to determine what we identify as outliers.
# Below we use code to identify which points they are and report their data.

# **Potential Outlier Obs/Row**:
# (We chose to leave outliers in as to not lose information. There are so few outliers and so much data that we do not feel any single point will be influential beyond reason.)

influential <- as.numeric(names(cooksd.1)[(cooksd.1 > 4*mean(cooksd.1, na.rm=T))])
influential <- as.data.frame(mesonet[influential, ])
influential
