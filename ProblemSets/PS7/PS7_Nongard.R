#Alex Nongard
#PS7

library(mice)
library(MixedDataImpute)
library(stargazer)
library(Hmisc)



wages<-read.csv("wages.csv")

wages<-wages[!(is.na(wages$hgc & wages$tenure)),]

#6.
stargazer(wages)
summary(wages$logwage)
560/2229
#the rate of missingness for logwages is 560/2229 = .2512337

wages$tenure2<-(wages$tenure)^2


#1
#wagescc<-subset(wages,!(logwage=="NA"))
wageslm<-lm(logwage~hgc+college+tenure+tenure2+age+married,wages, na.action=na.exclude)
wageslm
#logwages = .53 + .06hgc + .15notcollegegrad + .05tenure - .001tenure2 + .0004age - .02single 

#2
mean(na.omit(wages$logwage))
wagesmvi<-wages
wagesmvi$logwage[is.na(wagesmvi$logwage)]<-1.622102 
mvilm<-lm(logwage~hgc+college+tenure+tenure2+age+married,wagesmvi)
mvilm
#logwages = .70 + .05hgc + .17notcollegegrad + .04tenure - .001tenure2 + .0002age - .03single 

#3
wagespr<-wageslm
wagespred<-predict(wagespr,na.action=na.pass)
#I tried about a million combinations of different na.action options, cannot figure this one out for the life of me. 

#4
md.pattern(wages)

mousesalary<-mice(wages, m=5, method="pmm", maxit=50, seed=500)
wagesmice<-complete(mousesalary,1)

fit = with(mousesalary, lm(logwage~hgc+college+tenure+tenure2+age+married,wagesmice))
round(summary(pool(fit)),2)
#logwages = .52 + .06hgc + .14notcollegegrad + .05tenure - .00tenure2 + .00age - .03single 


stargazer(wageslm,mvilm)








