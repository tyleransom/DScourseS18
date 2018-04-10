# Erik Fretland
# PS7
# 3/13/18

install.packages('MixedDataImpute')
install.packages('mice')
install.packages('stargazer')

library(MixedDataImpute)
library(mice)
library(stargazer)

wages <- read.csv("wages.csv")

wages <- subset(wages, !is.na(wages$hgc))
wages <- subset(wages, !is.na(wages$tenure))

stargazer(wages)


# wages$college <- as.character(wages$college)
# wages$college[wages$college == "college grad"] <- "1"
# wages$college[wages$college == "not college grad"] <- "0"
# wages$college <- as.factor(wages$college)

# wages$married <- as.character(wages$married)
# wages$married[wages$married == "married"] <- "1"
# wages$married[wages$married == "single"] <- "0"
# wages$married <- as.numeric(wages$married)

wages$tenuresq <- (wages$tenure)^2

wages1 <- wages[complete.cases(wages), ]

attach(wages1)

# MAR CC regression
wagesccreg <- lm(wages1$logwage ~ hgc +college + tenure + tenuresq + age + married, data = wages1)
summary(wagesccreg)

detach(wages1)



#mean value imputation

wages2 <- wages

for(logwage in 1:ncol(wages2)){
  wages2[is.na(wages2[,"logwage"]), "logwage"] <- mean(wages2[,"logwage"], na.rm = TRUE)
}

wages2reg <- lm(wages2$logwage ~ hgc + college + tenure + tenuresq + age + married, data = wages2)
summary(wages2reg)


# complete cases predicted value

# mice imputation

wages3 <- mice(wages, m=5, maxit = 50, method = 'pmm', seed = 500)
summary(wages3)

micewages <- complete(wages3,1)

wages3reg <- with(wages3, lm(logwage ~ hgc + college + tenure + tenuresq + age + married))
summary(pool(wages3reg))

#stargazer tables

stargazer(wagesccreg, wages2reg, title = "Regression Comparison", align = TRUE)


