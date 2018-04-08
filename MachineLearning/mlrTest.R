library(mlr)

set.seed(100)

housing <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data")
names(housing) <- c("crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat","medv")

# From UC Irvine's website (http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.names)
#    1. CRIM      per capita crime rate by town
#    2. ZN        proportion of residential land zoned for lots over 
#                 25,000 sq.ft.
#    3. INDUS     proportion of non-retail business acres per town
#    4. CHAS      Charles River dummy variable (= 1 if tract bounds 
#                 river; 0 otherwise)
#    5. NOX       nitric oxides concentration (parts per 10 million)
#    6. RM        average number of rooms per dwelling
#    7. AGE       proportion of owner-occupied units built prior to 1940
#    8. DIS       weighted distances to five Boston employment centres
#    9. RAD       index of accessibility to radial highways
#    10. TAX      full-value property-tax rate per $10,000
#    11. PTRATIO  pupil-teacher ratio by town
#    12. B        1000(Bk - 0.63)^2 where Bk is the proportion of blacks 
#                 by town
#    13. LSTAT    % lower status of the population
#    14. MEDV     Median value of owner-occupied homes in $1000's

# Add some other features
housing$lmedv <- log(housing$medv)
housing$medv <- NULL
housing$dis2 <- housing$dis^2
housing$chasNOX <- housing$crim * housing$nox

# Break up the data:
n <- nrow(housing)
train <- sample(n, size = .8*n)
test  <- setdiff(1:n, train)
housing.train <- housing[train,]
housing.test  <- housing[test, ]

#####################
# Let's start with OLS (unregularized)
#####################
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

#####################
# Now let's do LASSO
#####################
library(glmnet)
# Tell it a new prediction algorithm
predAlg <- makeLearner("regr.glmnet")

# Search over penalty parameter lambda and force elastic net parameter to be 1 (LASSO)
modelParams <- makeParamSet(makeNumericParam("lambda",lower=0,upper=1),makeNumericParam("alpha",lower=1,upper=1))

# Take 50 random guesses at lambda within the interval I specified above
tuneMethod <- makeTuneControlRandom(maxit = 50L)

# Do the tuning
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

str(prediction)

# Performance
print(performance(prediction, measures = list(rmse)))

#####################
# Classification time!
#####################
library(rpart)

# Tell it a new task (classification instead of regression)
theTask <- makeClassifTask(id = "taskname", data = housing.train, target = "chas")

# Tell it a new prediction algorithm
predAlg <- makeLearner("classif.rpart", predict.type = "response")

# Search over complexity penalty parameters: tree depth, min leaf, etc.
modelParams <- makeParamSet(makeIntegerParam("minsplit",lower = 10, upper = 50), makeIntegerParam("minbucket", lower = 5, upper = 50), makeNumericParam("cp", lower = 0.001, upper = 0.2))

# Take 50 random guesses at each combination of penalty parameters
tuneMethod <- makeTuneControlRandom(maxit = 100L)

# Do the tuning
tunedModel <- tuneParams(learner = predAlg,
                        task = theTask,
                        resampling = resampleStrat,
                        measures = list(f1,acc,fpr,fnr),       # F1 performance measure, this can be changed to one or many
                        par.set = modelParams,
                        control = tuneMethod,
                        show.info = TRUE)

# Apply the optimal algorithm parameters to the model
predAlg <- setHyperPars(learner=predAlg, par.vals = tunedModel$x)

# Verify performance on cross validated sample sets
resample(predAlg,theTask,resampleStrat,measures=list(f1,acc,fpr,fnr))

# Train the final model
finalModel <- train(learner = predAlg, task = theTask)

# Predict in test set!
prediction <- predict(finalModel, newdata = housing.test)

# Performance
print(performance(prediction, measures = list(f1,acc,fpr,fnr)))

