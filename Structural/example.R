library(mlogit)
data(Heating) # load data on residential heating choice in CA
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
