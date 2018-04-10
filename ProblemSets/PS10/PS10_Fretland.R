

# Load packages
######################

library("rpart")
library("e1071")
library("kknn")
library("nnet")
library("mlr")
library("glmnet")


# Import data
######################

set.seed(100)

income <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data")

names(income) <- c("age","workclass","fnlwgt","education","education.num","marital.status","occupation","relationship","race","sex","capital.gain","capital.loss","hours","native.country","high.earner")

# From UC Irvine's website (http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.names)
#   age: continuous.
#   workclass: Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked.
#   fnlwgt: continuous.
#   education: Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool.
#   education-num: continuous.
#   marital-status: Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse.
#   occupation: Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces.
#   relationship: Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried.
#   race: White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black.
#   sex: Female, Male.
#   capital-gain: continuous.
#   capital-loss: continuous.
#   hours-per-week: continuous.
#   native-country: United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands.


# Organize the dataset
######################

# Drop unnecessary columns

income$native.country <- NULL
income$fnlwgt <- NULL

# Set continuous variables as continuous

income$age            <- as.numeric(income$age)
income$hours          <- as.numeric(income$hours)
income$education.num  <- as.numeric(income$education.num)
income$capital.gain   <- as.numeric(income$capital.gain)
income$capital.loss   <- as.numeric(income$capital.loss)

# Combine levels of categorical variables that currently have too many levels

levels(income$education)      <- list(Advanced = c("Masters,","Doctorate,","Prof-school,"), Bachelors = c("Bachelors,"), "Some-college" = c("Some-college,","Assoc-acdm,","Assoc-voc,"), "HS-grad" = c("HS-grad,","12th,"), "HS-drop" = c("11th,","9th,","7th-8th,","1st-4th,","10th,","5th-6th,","Preschool,"))
levels(income$marital.status) <- list(Married = c("Married-civ-spouse,","Married-spouse-absent,","Married-AF-spouse,"), Divorced = c("Divorced,","Separated,"), Widowed = c("Widowed,"), "Never-married" = c("Never-married,"))
levels(income$race)           <- list(White = c("White,"), Black = c("Black,"), Asian = c("Asian-Pac-Islander,"), Other = c("Other,","Amer-Indian-Eskimo,"))
levels(income$workclass)      <- list(Private = c("Private,"), "Self-emp" = c("Self-emp-not-inc,","Self-emp-inc,"), Gov = c("Federal-gov,","Local-gov,","State-gov,"), Other = c("Without-pay,","Never-worked,","?,"))
levels(income$occupation)     <- list("Blue-collar" = c("?,","Craft-repair,","Farming-fishing,","Handlers-cleaners,","Machine-op-inspct,","Transport-moving,"), "White-collar" = c("Adm-clerical,","Exec-managerial,","Prof-specialty,","Sales,","Tech-support,"), Services = c("Armed-Forces,","Other-service,","Priv-house-serv,","Protective-serv,"))

# Break up the data:

n            <- nrow(income)
train        <- sample(n, size = .8*n)
test         <- setdiff(1:n, train)
income.train <- income[train,]
income.test  <- income[test, ]


# Create Objects
######################

# Define the task

the.task <- makeClassifTask(data = income.train, target = "high.earner")

# Set resampling strategy (3-fold CV)

resample.strat <- makeResampleDesc(method = "CV", iters = 3)

# Take 10 random guesses at lambda within the interval specified above

tune.method <- makeTuneControlRandom(maxit = 10L)

# Create each of the six learners

tree.alg  <- makeLearner("classif.rpart", predict.type = "response")
lreg.alg  <- makeLearner("classif.glmnet", predict.type = "response")
nn.alg    <- makeLearner("classif.nnet", predict.type = "response")
bayes.alg <- makeLearner("classif.naiveBayes", predict.type = "response")
knn.alg   <- makeLearner("classif.kknn", predict.type = "response")
svm.alg   <- makeLearner("classif.svm", predict.type = "response")




# Create hyperparameters
######################

params.tree <- makeParamSet(makeIntegerParam("minsplit",lower = 10, upper = 50), 
                            makeIntegerParam("minbucket", lower = 5, upper = 50), 
                            makeNumericParam("cp", lower = 0.001, upper = 0.2))
params.lreg <- makeParamSet(makeNumericParam("lambda", lower = 0, upper = 3), 
                            makeNumericParam("alpha", lower = 0, upper = 1))
params.nn   <- makeParamSet(makeIntegerParam("size", lower = 1, upper = 10), 
                            makeNumericParam("decay", lower = 0.1, upper = 0.5), 
                            makeIntegerParam("maxit", lower = 1000, upper = 1000))
params.knn  <- makeParamSet(makeIntegerParam("k", lower = 1, upper = 30))
params.svm  <- makeParamSet(makeDiscreteParam("radial", values = 2^c(-2, -1, 0, 1, 2, 10)), 
                            makeDiscreteParam("cost", values = 2^c(2^-2, -1, 0, 1, 2, 10)), 
                            makeDiscreteParam("gamma", values = 2^c(-2, -1, 0, 1, 2, 10)))


######################
# Tune the models
######################


tuned.tree    <- tuneParams(learner = tree.alg,
                            task = the.task,
                            resampling = resample.strat,
                            measures = list(f1, gmean),
                            par.set = params.tree,
                            control = tune.method,
                            show.info = TRUE)
tuned.lreg    <- tuneParams(learner = lreg.alg,
                            task = the.task,
                            resampling = resample.strat,
                            measures = list(f1, gmean),
                            par.set = params.lreg,
                            control = tune.method,
                            show.info = TRUE)
tuned.nn      <- tuneParams(learner = nn.alg,
                            task = the.task,
                            resampling = resample.strat,
                            measures = list(f1, gmean),
                            par.set = params.nn,
                            control = tune.method,
                            show.info = TRUE)
tuned.knn     <- tuneParams(learner = knn.alg,
                            task = the.task,
                            resampling = resample.strat,
                            measures = list(f1, gmean),
                            par.set = params.knn,
                            control = tune.method,
                            show.info = TRUE)
tuned.svm     <- tuneParams(learner = svm.alg,
                            task = the.task,
                            resampling = resample.strat,
                            measures = list(f1, gmean),
                            par.set = params.svm,
                            control = tune.method,
                            show.info = TRUE)


######################
# Results
######################

# Apply the optimal algorithm parameters to the model

tree.alg <- setHyperPars(learner = tree.alg, par.vals = tuned.tree$x)
lreg.alg <- setHyperPars(learner = lreg.alg, par.vals = tuned.lreg$x)
nn.alg   <- setHyperPars(learner = nn.alg, par.vals = tuned.nn$x)
knn.alg  <- setHyperPars(learner = knn.alg, par.vals = tuned.knn$x)
svm.alg <- setHyperPars(learner = svm.alg, par.vals = tuned.svm$x)


# Resample each learner

resample.tree  <- resample(learner = tree.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))
resample.lreg  <- resample(learner = lreg.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))
resample.nn    <- resample(learner = nn.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))
resample.bayes <- resample(learner = bayes.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))
resample.knn   <- resample(learner = knn.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))
resample.svm   <- resample(learner = svm.alg, task = the.task, resampling = resample.strat, measures=list(f1, gmean))


# Train the final model 

final.tree  <- train(learner = tree.alg, task = the.task)
final.lreg  <- train(learner = lreg.alg, task = the.task)
final.nn    <- train(learner = nn.alg, task = the.task)
final.bayes <- train(learner = bayes.alg, task = the.task)
final.knn   <- train(learner = knn.alg, task = the.task)
final.svm   <- train(learner = svm.alg, task = the.task)


# Predict in test set

prediction.tree  <- predict(final.tree, newdata = income.test)
prediction.lreg  <- predict(final.lreg, newdata = income.test)
prediction.nn    <- predict(final.nn, newdata = income.test)
prediction.bayes <- predict(final.bayes, newdata = income.test)
prediction.knn   <- predict(final.knn, newdata = income.test)
prediction.svm   <- predict(final.svm, newdata = income.test)


# Model Evaluation (measured in out of sample F1 and gmean)

performance(prediction.tree, measures = list(f1, gmean))
performance(prediction.lreg, measures = list(f1, gmean))
performance(prediction.nn, measures = list(f1, gmean))
performance(prediction.bayes, measures = list(f1, gmean))
performance(prediction.knn, measures = list(f1, gmean))
performance(prediction.svm, measures = list(f1, gmean))


# Make Table
ModelNames <- c("Tree", "LReg", "NeuralNet", "Bayes", "KNN", "SVM")
F1Values <- c(0.8968421, 0.8968422, 0.9059474, 0.8825952, 0.8985478, 0.9016329)
GMeans <- c(0.6730932, 0.6762722, 0.7600248, 0.730489, 0.7543678, 0.7417364)
PerformanceTable <- data.frame(ModelNames, F1Values, GMeans)
print(PerformanceTable)

library(stargazer)
stargazer(PerformanceTable, summary = FALSE)
