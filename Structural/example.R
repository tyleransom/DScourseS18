#### Binary choice model
library(mlogit)

# load data on residential heating choice in CA
data(Heating) 
levels(Heating$depvar) <- c("gas","gas","elec","elec","elec")

# estimate logit and get predicted probabilities
estim <- glm(depvar ~ income+agehed+rooms+region,family=binomial(link='logit'),data=Heating)
print(summary(estim))
Heating$predLogit <- predict(estim, newdata = Heating, type = "response")
print(summary(Heating$predLogit))

# estimate probit and get predicted probabilities
estim2 <- glm(depvar ~ income+agehed+rooms+region,family=binomial(link='probit'),data=Heating)
print(summary(estim2))
Heating$predProbit <- predict(estim2, newdata = Heating, type = "response")
print(summary(Heating$predProbit))


# counterfactual policy: electric heating subsidy to higher-income folks
estim$coefficients["income"] <- 4*estim$coefficients["income"]
Heating$predLogitCfl <- predict(estim, newdata = Heating, type = "response")
print(summary(Heating$predLogitCfl))



#### Heckman selection model (from Garrett Glasgow's website)
library(sampleSelection)

# Load "Mroz" data on labor supply, fertility, and wages
data("Mroz87")
Mroz87$kids <- (Mroz87$kids5 + Mroz87$kids618 > 0)
head(Mroz87)

## Comparison of linear regression and selection model
outcome1 <- lm(wage ~ exper, data = Mroz87)
print(summary(outcome1))

selection1 <- selection(selection = lfp ~ age + I(age^2) + faminc + kids + educ, outcome = wage ~ exper, 
			data = Mroz87, method = "2step")
print(summary(selection1))


