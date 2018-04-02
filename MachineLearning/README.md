# Machine Learning

The next unit of this class will cover machine learning. But first, let's discuss the difference between Machine Learning and Artificial Intelligence (AI).

## What is machine learning? What is AI?

What is machine learning?

* **ML:** Allowing computers to learn for themselves without being explicitly programmed
    * **USPS:** Computers read handwritten addresses and sort mail accordingly
    * **Google:** AlphaGo, AlphaZero (computers that are world-class chess, go players)
    * **Apple/Amazon/Microsoft:** Siri, Alexa, Cortana voice assistants can understand human speech
    * **Facebook:** automatically finds faces in a photo and tags them to the corresponding user
* In each of the above examples, the machine is "learning" to do something only humans had previously been able to do
* Put differently, the machine was not programmed to read numbers or recognize voices -- it was given a bunch of examples of numbers and human voices and came up with a way to predict what's a number or a voice and what isn't

What is AI?

* **AI:** Constructing machines (robots, computers) to think and act like human beings

Thus, machine learning is a (large) subset of AI

## Machine learning's role in data science

* In data science, machine learning closely resembles statistics.
* Why? Because a lot of data science is about finding "insights" or "policies" in your data that can be used to increase profits or improve quality of life in some other dimension.
* Finding "insights" is about finding correlative and causal relationships among variables
* Statistics is the science that has the vast majority of these tools

## Machine learning vs. econometrics

* **Machine Learning** is all about maximizing and out-of-sample prediction
* **Econometrics** is all about finding "consistent" parameter estimates (e.g. making sure that the estimated parameters of the model will converge to their "true" values given a large enough sample size)
* **Machine Learning** is all about finding y&#770;
* **Econometrics** is all about finding &beta;&#770;

## The fundamental objective of Machine Learning
The fundamental objective is to maximize out-of-sample fit

* But how is this possible given that -- by definition -- we don't see what's not in our sample?
* The solution is to choose functions that predict well in-sample, but penalize them from being too complex.
* **Regularization** is the tool by which in-sample fit is penalized. That is, regularization prevents overly complex functions from being chosen by the algorithm
* **Overfitting** is when we put too much emphasis on in-sample fit, leading us to make poor out-of-sample fit

## Elements of Machine Learning
The following are the basic elements of machine learning in data science:

1. Loss function (this is how one measures how well a particular algorithm predicts in- or out-of-sample)
2. Algorithm (a way to generate prediction rules in-sample that can generate to out-of-sample)
3. Training data (the sample on which the algorithm estimates)
4. Validation data (the sample on which algorithm tuning occurs)
5. Test data (the "out-of-sample" data which is used to measure predictive power on unseen cases)

The algorithm typically comes with **tuning parameters** which are ways to regularize the in-sample fit

**Cross-validation** is how tuning parameters are tuned.

## Example
* Suppose you want to predict housing prices (this is the "hello world" of machine learning)
* You have a large number of relevant variables
* What would you do?
    * You would want to have a model that can detect non-linear relationships (like the USPS handwriting reader)
    * You would also want to have a model that you can tractably estimate
    * And a model that will predict well out-of-sample

### One option: a separate dummy variable for every house
* In this scneario, you run `lm(log(price) ~ as.factor(houseID))`
* What you get is a separate price prediction for every single house
* But what to do when given a new house that's not in the sample?
    * Which house in the sample is the one you should use for prediction?
* The resulting prediction will have horrible out-of-sample fit, even though it has perfect in-sample fit
* This is a classic case of **overfitting**
* We say that this prediciton has **high variance** (i.e. the algorithm thinks random noise is something that is important to the model)

### Another option: house price is a linear function of square footage
* In this scenario, you simple run `lm(log(price) ~ sqft)`
* When given a new hosue with a given square footage, you will only look at the square footage to predict the price of the new house
* This algorithm will result in **underfitting** because the functional form and features it uses for prediction is too simplistic
* We say that this prediction has **high bias** (i.e. the algorithm does not think enough variation is important to the model)

## Bias-variance tradeoff
The **bias-variance tradeoff** refers to the fact that we need to find a model that is complex enough to generalize to new datasets, but is simple enough that it doesn't "hallucinate" random noise as being important

The way to optimally trade off bias and variance is via **regularization**

The following graphic from p. 194 of Hastie, Tsibshirani, and Friedman's *Elements of Statistical Learning* illustrates this tradeoff:

![Source: p. 194 of *Elements of Statistical Learning*](../Graphics/biasVarianceHTFp194.png "Bias-Variance Tradeoff")

## Regularization methods

1. Regression models (OLS or logistic)
    * L0 (Subset selection): penalize objective function by sum of the parameters &ne;0
    * L1 (LASSO): penalize objective function by sum of absolute value of parameters
    * L2 (Ridge): penalize objective function by sum of square of parameters 
    * Elastic net: penalize by a weighted sum of L1 and L2
2. Tree models
    * Depth, number of leaves, minimal leaf size, other criteria
3. Random forests
    * Number of trees, complexity of each tree, other criteria
4. Nearest neighbors
    * Number of neighbors
5. Neural networks
    * Number of layers, number of neurons per layer, connectivity between neurons (i.e. via L1/L2 regularization)
6. Support Vector Machine
    * L1/L2 regularization
7. Naive bayes
    * Naturally geared towards not overfitting, but can be regularized with iterative variable selection algorithms (similar to stepwise/stagewise regression)

## Visualization of different predictors
The following graphic shows a visualization of different classification algorithms, accross two features (call them X and Y). Note the stark differences in the prediction regions.

![Source: Sebastian Raschka on twitter](../Graphics/DYTAagSVAAACVc7.jpg "Comparison of different machine learning classification algorithms")

Source: [this tweet](https://twitter.com/rasbt/status/974115063308091392?s=12)

## Combined predictors
Often you can get a better prediction by combining multiple sets of prediction. We call these **combined predictors**. 

You can think of the combined predictor as a "committee of experts." Each "expert" votes on the outcome and votes are aggregated in such a way that the resulting prediction ends up being better than any individual component prediction.

3 types of combined predictors (cf. Mullainathan & Spiess, 2017):

1. Bagging (unweighted average of predictors from bootstrap draws)
2. Boosting (linear combination of predictions of a residual)
3. Ensemble (weighted combination of different predictors)

Combined predictors are regularized in the number of draws, number of iterations, or structure of the weights.

## Visualization of combined predictors
The following graphic shows a similar visualization as above, but now incorporates an ensemble prediction region. This provides some solid intuition for why ensemble predictors usually perform better than the predictions from any one algorithm.

![Source: Sebastian Raschka on twitter](../Graphics/ensemble_decision_regions_2d.png "Comparison of different machine learning classification algorithms and an ensemble prediction")

Source: [The `mlxtend` GitHub repository](https://github.com/rasbt/mlxtend)

## Measuring prediction accuracy
How do we measure prediction accuracy? It depends on if our target variable is continuous or categorical

* **If continuous:** Use *Mean Squared Error (MSE)* which is equal to the sum of the squared differences between y and y&#770; divided by the sample size. Sometimes the *Root Mean Squared Error (RMSE)* is used, which is the square root of this quantity. You may also see the *Mean Absolute Error (MAE)* which is the sum of the absolute value of the differences between y and y&#770; divided by the sample size.
* **If binary:** Use the *confusion matrix* which compares how often y and y&#770; agree with each other (i.e. for what fraction of cases y&#770; = 0 when y = 0)

Example confusion matrix

|    | y&#770; |  |
|--------|-----|-------|
| y | 0  | 1 |
| 0 | True negative   | False positive |
| 1 | False negative  |  True positive |

## Using the confusion matrix
The three most commonly used quantities that are computed from the confusion matrix are:

1. **sensitivity (aka recall):** what fraction of y = 1 have y&#770; = 1 ? (What is the true positive rate?)
2. **specificity:** what fraction of y = 0 have y&#770; = 0 ? (What is the true negative rate?)
3. **precision:** what fraction of y&#770; = 1 have y = 1 ? (What is the rate at which positive predictions are true?)

The goal is to trade off Type I and Type II errors in classification. The **F1 score** is the most common way to quantify this tradeoff.

* F1 score = 2/(1/recall  +  1/precision); a number in [0,1] with 1 being best
* It is the harmonic mean of recall and precision

There are a bunch of other quantities that one could compute from the confusion matrix, but we won't cover any of those.

## Why use the confusion matrix?
When assessing the predictive accuracy of a classification problem, we want to make sure that we can't "game" the accuracy measure by always predicting "negative" (or always predicting "positive"). This is critical for cases like classifying emails as "spam" or "ham" because of the relative paucity of "spam" messages.

In other words, if spam messages are only 1% of all messages seen, we don't want to be able to always predict "ham" and have that be a better measure of accuracy than actually trying to pin down the 1% of spam messages.

The F1 measure attempts to quantify the tradeoff between Type I and Type II errors (false negatives and false positives) that would be rampant if we were to always predict "ham" in the email example.

## Cross validation
How do we decide what level of complexity our algorithm should be, especially when we can't see out-of-sample?

The answer is we choose values of the **tuning parameters** that maximize out-of-sample prediction

for example:

* the &lambda; that comes in front of L1, L2, and elastic net regularization
* the maximum depth of the tree or the min. number of observations within each leaf
* etc.

## Splitting the sample
To peform cross-validation, one needs to split the sample. There are differing opinions on this:

Camp A ("Holdout")

1. Training data (~70%)
2. Test ("holdout") data (~30%)

Camp B ("Cross-validation")

1. Training data (~60%)
2. Validation data (~20%)
3. Test data (~20%)

Sample is split randomly, **or** randomly according to how it was generated (e.g. if it's panel data, sample *units*, not observations)

It is ideal to follow the "Cross-validation" camp, but in cases where you don't have many observations (training examples), you may have to go the "Holdout" route.

## k-fold cross-validation
Due to randomness in our data, it may be better to do the cross validation multiple times. To do so, we take the 80% training-plus-validation sample and randomly divide it into the 60/20 components k number of times. Typically k is between 3 and 10. (See graphic below)

![Source: Brant Deppa, Winona State Univ.](../Graphics/k-foldCV.png "Illustration of k-fold cross validation")

In the extreme, one can also do *nested* k-fold cross-validation, wherein the test set is shuffled some number of times and the k-fold CV is repeated each time. So we would end up with "3k" fold CV, for example. For simplicity, we'll only use simple k-fold CV in this course.

## How to do all of this in R 
There are a couple of nice packages in R that will do k-fold cross validation for you, and will work with a number of commonly used prediction algorithms

1. `caret`
2. `mlr`

`caret` likely still has a strong following, but `mlr` is up-and-coming and has a better user interface. We'll be using `mlr` for the rest of this unit of the course

In Python, `scikit-learn` is the workhorse machine learning frontend.

## How to use `mlr`
You need to tell `mlr` the following information before it will run:

1. Training data (which will end up being split k ways when doing cross-validation)
2. Testing data
3. The task at hand (e.g. regression or classification)
4. The validation scheme (e.g. 3-fold, 5-fold, or 10-fold CV)
5. The method used to tune the parameters of the algorithm (e.g. &lambda; for LASSO)
6. The prediction algorithm (e.g. "decision tree")
7. The parameters of the prediction algorithm that need to be cross-validated (e.g. tree depth, &lambda;, etc.)

For a complete list of prediction algorithms supported by `mlr`, see [here](http://mlr-org.github.io/mlr-tutorial/devel/html/integrated_learners/index.html)

## Simple example
Let's start by doing linear regression on a well-known dataset: the Boston housing data from UC Irivne:

```r
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
```

## OLS

```r
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
```

Now, there's not much to do here, since there is no regularization in OLS. But you can see that there is quite a bit of variation in the RMSE based on which sample you use.

## LASSO
Now let's repeat but instead use the LASSO estimator from the `glmnet` package

Since `mlr` is awesome, we only need to load the package, reset the `makeLearner` function, and add the tuning over the &lambda; parameter

```r
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
```

## LASSO (continued)
The workhorse of the cross-validation is done by calling the `tuneParams` function. Once we have that, we need only to train the alogrithm with the optimal parameters and then use them for prediction

```r
# Apply the optimal algorithm parameters to the model
predAlg <- setHyperPars(learner=predAlg, par.vals = tunedModel$x)

# Verify performance on cross validated sample sets
resample(predAlg,theTask,resampleStrat,measures=list(rmse))

# Train the final model
finalModel <- train(learner = predAlg, task = theTask)

# Predict in test set!
prediction <- predict(finalModel, newdata = housing.test)

print(head(prediction$data))
```

## Ridge regression
We could do ridge regression on the same data by instead setting `alpha` to be 0 (instead of 1). In this case, all we would need to do is adjust the `makeParamSet()` function, re-call the tuning function, re-compute the in-sample fit of the tuned model, and re-compute the out-of-sample fit of the optimally tuned model:

```r
# Search over penalty parameter lambda and force elastic net parameter to be 0 (ridge)
modelParams <- makeParamSet(makeNumericParam("lambda",lower=0,upper=1),makeNumericParam("alpha",lower=0,upper=0))

# Do the tuning again
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
```
This showcases the nicest feature of the `mlr` package: we are still using the same algorithm, data, and cross-validation scheme, so we don't need to tell it those parameters again. We do, however, need to tell it to tune to the new parameter space (in this case, ridge instead of LASSO).

# Helpful links
* [Mullainathan & Spiess (2017)](https://www.aeaweb.org/articles?id=10.1257/jep.31.2.87&within%5Btitle%5D=on&within%5Babstract%5D=on&within%5Bauthor%5D=on&journal=3&q=mullainathan&from=j)
* [Kaggle notebook by Pondering Panda, showing how to use `mlr`](https://www.kaggle.com/xanderhorn/train-r-ml-models-efficiently-with-mlr)
* [Complete list of `mlr` algorithms](http://mlr-org.github.io/mlr-tutorial/devel/html/integrated_learners/index.html)
* [Quick start `mlr` tutorial](https://mlr-org.github.io/mlr-tutorial/release/html/index.html)
* Laurent Gatto's [*An Introduction to Machine Learning with R*](https://lgatto.github.io/IntroMachineLearningWithR/) online textbook
