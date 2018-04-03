# Erik Fretland
# PS9
# 4/2/18

install.packages('mlr')
install.packages('glmnet')
library(mlr)
library(glmnet)

# Read Data in

housing <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data")
names(housing) <- c("crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat","medv")


housing $ lmedv <- log ( housing $ medv)
housing $ medv <- NULL # drop median value
housformula <- as.formula(lmedv ~ .^3 +
                          poly(crim, 6) +
                          poly(zn, 6) +
                          poly(indus, 6) +
                          poly(nox, 6) +
                          poly(rm, 6) +
                          poly(age, 6) +
                          poly(dis, 6) +
                          poly(rad, 6) +
                          poly(tax, 6) +
                          poly(ptratio, 6) +
                          poly(b, 6) +
                          poly(lstat, 6))
mod_matrix <- data.frame (model.matrix(housformula, housing ))
#now replace the intercept column by the response since MLR will do
#"y ~ ." and get the intercept by default
mod_matrix[, 1] <- housing$lmedv
colnames(mod_matrix)[1] = "lmedv" # make sure to rename it otherwise MLR won't find it
head(mod_matrix) #just make sure everything is hunky -dory
# Break up the data:
n <- nrow(mod_matrix)
train <- sample(n, size = .8*n)
test <- setdiff(1:n, train)
housing.train <- mod_matrix[train,]
housing.test <- mod_matrix[test, ]

# start with OLS base model

# Define the task:
theTask <- makeRegrTask(id = "taskname", data = housing.train, target = "lmedv")
print(theTask)

# tell mlr what prediction algorithm we'll be using (OLS)
predAlg <- makeLearner("regr.lm")

# Set resampling strategy (here let's do 6-fold CV)
resampleStrat <- makeResampleDesc(method = "CV", iters = 6)

# Do the resampling
sampleResults <- resample(learner = predAlg, task = theTask, resampling = resampleStrat, measures=list(rmse))

# Mean RMSE across the 6 folds
print(sampleResults$aggr)

#LASSO

library(glmnet)

predAlg <- makeLearner("regr.glmnet")

modelParams <- makeParamSet(makeNumericParam("lambda", lower=0, upper =1),makeNumericParam("alpha", lower=1, upper=1))

tuneMethod <- makeTuneControlRandom(maxit = 50L)

tunedModel <- tuneParams(learner = predAlg,
                         task = theTask,
                         resampling = resampleStrat,
                         measures = rmse,       # RMSE performance measure, this can be changed to one or many
                         par.set = modelParams,
                         control = tuneMethod,
                         show.info = TRUE)

# Apply the optimal algorithm parameters to the model
predAlg <- setHyperPars(learner=predAlg, par.vals = tunedModel$x)

# Verify performance on cross validated sample sets
resample(predAlg,theTask,resampleStrat,measures=list(rmse))

# Train the final model
finalModel <- train(learner = predAlg, task = theTask)

# Predict in test set!
prediction <- predict(finalModel, newdata = housing.test)

print(head(prediction$data))

# Trying to identify the ideal lambda

tunedModel$lambda.min






# Ridge Regression

# Search over penalty parameter lambda and force elastic net parameter to be 0 (ridge)
modelParams2 <- makeParamSet(makeNumericParam("lambda",lower=0,upper=1),makeNumericParam("alpha",lower=0,upper=0))

# Do the tuning again
tunedModel2 <- tuneParams(learner = predAlg,
                         task = theTask,
                         resampling = resampleStrat,
                         measures = rmse,       # RMSE performance measure, this can be changed to one or many
                         par.set = modelParams2,
                         control = tuneMethod,
                         show.info = TRUE)

# Apply the optimal algorithm parameters to the model
predAlg2 <- setHyperPars(learner=predAlg, par.vals = tunedModel2$x)

# Verify performance on cross validated sample sets
resample(predAlg2,theTask,resampleStrat,measures=list(rmse))

# Train the final model
finalModel2 <- train(learner = predAlg2, task = theTask)

# Predict in test set!
prediction2 <- predict(finalModel2, newdata = housing.test)

print(head(prediction2$data))

# Trying to identify the ideal lambda

tunedModel2$lambda.min



# Elastic Net Model

# Search over penalty parameter lambda and set elastic net parameter with the boundaries 0 and 1
modelParams3 <- makeParamSet(makeNumericParam("lambda",lower=0,upper=1),makeNumericParam("alpha",lower=0,upper=1))

# Do the tuning again
tunedModel3 <- tuneParams(learner = predAlg,
                          task = theTask,
                          resampling = resampleStrat,
                          measures = rmse,       # RMSE performance measure, this can be changed to one or many
                          par.set = modelParams3,
                          control = tuneMethod,
                          show.info = TRUE)

# Apply the optimal algorithm parameters to the model
predAlg3 <- setHyperPars(learner=predAlg, par.vals = tunedModel3$x)

# Verify performance on cross validated sample sets
resample(predAlg3,theTask,resampleStrat,measures=list(rmse))

# Train the final model
finalModel3 <- train(learner = predAlg3, task = theTask)

# Predict in test set!
prediction3 <- predict(finalModel3, newdata = housing.test)

print(head(prediction3$data))

# Trying to identify the ideal lambda

tunedModel3$lambda.min






# HW9 Questions
lassoperformance <- performance(prediction, measures = list(rmse))
lassoperformance

ridgeperformance <- performance(prediction2, measures = list(rmse))
ridgeperformance

elasticnetperformance <- performance(prediction3, measures = list(rmse))
elasticnetperformance


