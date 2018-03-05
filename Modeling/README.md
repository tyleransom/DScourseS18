# Intro to statistical modeling
These notes will show an overview of statistical modeling. We will cover how to model outcomes of various varieties and briefly discuss the pros and cons of various modeling approaches. 

## Fundamentals of modeling
So, you have some data. Now you need to write down a model of how the variables in the data interact with each other.

* Why do I need a model?

    - because you're interested in either predicting some outcome variable (like sales)

    - or because you're interested in understanding a causal relationship (e.g. between advertising and sales)


### The types of variables in a model

1. Outcome variable (typically denoted **y**), aka:
    * response variable
    * dependent variable
    * target variable
2. Covariates (typically denoted **x**), aka:
    * predictors
    * features
    * independent variables
    * control variables
3. Parameters (typically denoted **&beta;** or **&theta;**):
    * map covariates into outcomes
4. Error term (typically denoted **&epsilon;**), aka:
    * unobservables
    * distrubance term

### What is a model?

A **model** is a mapping between covariates, parameters, unobservables, and outcomes. It is the "production function" that generates the outcome we are interested in.

Most generally, the model is:

y = f(x,&theta;,&epsilon;)

The model can be as simple as

y = &beta;<sub>0</sub> + &beta;<sub>1</sub>x<sub>1</sub> + &beta;<sub>2</sub>x<sub>2</sub> + &epsilon;

or it can be as complex as

y = &beta;<sub>0</sub>x<sub>1</sub><sup>(&beta;<sub>1</sub>)<sup>&beta;<sub>2</sub>x<sub>2</sub></sup></sup>e<sup>&epsilon;</sup>

A model can even have a &theta; that is *infinite-dimensional*. We call this a **non-parametric** model. (Equivalently, a non-parametric model is one in which we do not make any assumption about the distribution from which &epsilon; is drawn.)

## The types of variables
Variables can be: 

* continuous
* binary
* categorical (ordered)
* categorical (unordered)
* integers (i.e. counts)

Note that both dependent and independent variables can be of these types

## Modeling dependent variables
For each type of dependent variable, we can come up with a statistical model to describe the relationship between the dependent variable and the covariates and unobservables.

All models fall under two umbrellas:

1. Parametric
2. Nonparametric
 
 
* The advantage of a parametric model is that one can interpret the model by looking at the parameters. The disadvantage is that it may not always be flexible enough to fit the data perfectly.

* The advantage of a nonparametric model is that it typically fits the data better. The disadvantage is that it may not be readily interpretable.

## Continuous dependent variables
A variable is **continuous** if it takes on any real number over some range (typically the entire real number line or the positive real numbers)

**Examples:** sales, earnings, number of page clicks, etc.

The table below lists examples of parametric and nonparametric models appropriate for dependent variables that are continuous.

| Parametric | Nonparametric |
|------------|---------------|
| OLS        | regression tree (forest, etc.) |
| Quantile regression | support vector machine (including k-nearest neighbor) |
| naive Bayes regression | Artificial Neural Network (ANN) |
|            | genetic programming (GP) |
|            | ... |

## Binary dependent variables
A variable is **binary** if it only takes on two values (without loss of generality: 0 or 1)

**Examples:** product was purchased by customer (or not), individual has cancer (or not), loan is in default (or not)


| Parametric | Nonparametric |
|------------|---------------|
| Logistic regression | classification tree (forest, etc.) |
| Probit regression | support vector classifier |
| naive Bayes classification | Artificial Neural Network (ANN) |
|            | genetic programming (GP) |
|            | ... |

## Ordered categorical dependent variables (aka Ordinal variables)
A variable is **ordered categorical** if it takes on a finite (typically small) set of values (without loss of generality: 0, 1, ..., K) and where *order matters* (i.e. K > K-1 > K-2 > ... > 1 > 0). Values are mutually exclusive, so that each observation in the data belongs to one and only one category.

**Example 1:** consumer has "interest" in a product by either: (0) not clicking on it; (1) clicking on it but not adding it to the cart; (2) adding it to the cart but not purchasing it; (3) purchasing it once; or (4) purchasing it multiple times

**Example 2:** a loan is either: (0) neither in default nor foreclosure; (1) in default but not in foreclosure; or (2) in foreclosure

| Parametric | Nonparametric |
|------------|---------------|
| Ordered logistic regression | ordinal trees |
| Ordered probit regression |support vector ordinal regression |
|            | ANN |
|            | GP |
|            | ... |


## Unordered categorical dependent variables
A variable is **unordered categorical** if it takes on a finite (typically small) set of values (without loss of generality: 0, 1, ..., K) but where *there is no inherent ordering among the categories*. Values are mutually exclusive, so that each observation in the data belongs to one and only one category.

**Example 1:** consumer can purchase: (0) no handbags; (1) Louis Vuitton handbags; (2) Coach handbags; (3) Other designer handbags; or (4) non-designer ("generic") handbags

**Example 2:** a person can choose to live in either: (0) Oklahoma City metro area; (1) Tulsa metro area; or (2) somewhere else in Oklahoma

The algorithms here are exactly the same as for binary dependent variables, except that now there are multiple categories.


| Parametric | Nonparametric |
|------------|---------------|
| Multinomial logistic regression | classification tree (forest, etc.) |
| Multinomial probit regression | support vector classifier |
| naive Bayes classification | Artificial Neural Network (ANN) |
|            | genetic programming (GP) |
|            | ... |


## Integer-valued dependent variables
A variable is **integer-valued** if it takes on values in the set of integers (0, 1, 2, ..., &infin;). Sometimes data that has this property is referred to as **count data**.

**Example 1:** consumer can smoke 0, 1, or more cigarettes in a day.

**Example 2:** a soccer team can score 0, 1, ..., 8 goals in a game.

**Example 3:** a city can experience 0, 1, or more vehicle accidents in a day.

Depending on the setting, some researchers will simply assume log-normality of the dependent variable in this case. Again, a choice like this really depends on the exact case.

The parametric algorithms for modeling count data are a bit different from before, but the nonparametric algorithms are quite similar:


| Parametric | Nonparametric |
|------------|---------------|
| Poisson regression | regression tree (forest, etc.) |
| Negative binomial regression | support vector machine |
| zero-inflated count models | Artificial Neural Network (ANN) |
| zero-truncated count models | genetic programming (GP) |
|            | ... |


## Independent variables
As mentioned previously, we can have all kinds of independent variables. Some helpful things to know about independent variables:

* don't treat an ordered categorical variable as a continuous variable
* use "one-hot" encoding of categorical variables (equivalently `as.factor()` in R)
* if using a liner regression model, it is sometimes helpful to create polynomial functions of continuous covariates
* interacting two binary covariates (or a binary and a continuous covariate) can also be helpful

** How you specify your right hand side variables depends a lot on the goal of your model (i.e. prediction vs. causality)**

## Observational vs. Experimental data
**Observational data** is data that has been collected for no particular purpose.
- e.g. Census household survey data, twitter stream, Dow Jones stock prices, etc.

**Experimental data** is data that scientists have set up where certain units are randomly assigned to take on certain values of a variable of interest (the **treatment variable**)

**Causal inference** (as opposed to prediction) is the idea that we can figure out if **x** causes **y** by comparing units that were treated with those that were not treated. 

Causal inference requires knowing the "counterfactual": "What would have happened to units in the control group if they had been treated?"

## Estimating statistical models in R, Python, and Julia

Libraries and functions (`library::function`)

| Algorithm | R | Python | Julia | 
|----------|----|--------|-------|
| OLS                        | `base::lm` | `statsmodels::OLS` | `GLM::glm` |
| trees                      | `rpart::rpart` | `sklearn::tree` | `DecisionTree::build_tree` |
| k-nearest neighbor         | `caret::knn3`  | `sklearn::KNeighborsClassifier` |  `NearestNeighbors::knn`     |
| SVM                        | `e1071::svm`  | `sklearn::svm` |  `LIBSVM::svmtrain`     |
| naive Bayes                | `e1071::naiveBayes`   | `sklearn::GaussianNB` | `NaiveBayes::HybridNB` |
| ANN                        | `nnet::nnet` | `sklearn::neural_network` | `Knet::train` |
| genetic prog.              | `rgp::geneticProgramming` | `gplearn::est_gp.fit` | `GeneticAlgorithms::runga` |
| logistic/probit regression | `base::glm`   | `sklearn::linear_model.LogisticRegression` | `GLM::glm` |
| ordered logit/probit       | `MASS:polr` | `mord::LogisticIT` | `LowRankModels::OrderedMultinomialLoss` |
| multionmial logit/probit   | `nnet::multinom` | same as logistic | `SciKitLearn::LogisticRegression` |
| Poisson regression         | `base::glm` | `statsmodels::GLM` | `GLM::glm` |


## Useful Links

* [Multiclass classification](https://en.wikipedia.org/wiki/Multiclass_classification)
* [One-hot encoding](https://en.wikipedia.org/wiki/One-hot)
* [Genetic programming example in R](https://www.kaggle.com/olegtereshkin/genetic-programming-r-example/code)
