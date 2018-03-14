# Basics for coding optimization problems
This document will give the reader an introduction to numerical optimization and the various trade-offs associated with the most common optimization algorithms. We will also cover how to code and evaluate an optimization problem in R. At the end, we will discuss what the cost function looks like for the most well-known statistical models and ML algorithms

## Basics of functional optimization

- All statistical estimators are either minima of some error (aka "cost") function or maxima of some likelihood function
    * Examples:
    * linear regression (OLS)
    * logistic regression
    * naive Bayes classification
    * Multi-Layer Perceptron (MLP) aka artifical neural networks (ANN)
    * support vector machine (SVM)
    * ... 
    * many others
- Some estimators (e.g. OLS, Generalized Method of Moments) have **closed form** solutions for the extremum value
    * we covered this in our previous lecture
- Other estimators (e.g. MLE, some non-linear least squares) require **numerical methods** to find the extremum value
    * we also showed this in the previous lecture (the case of logistic regression)
- There are a number of different algorithms to numerically find extrema ("guess-and-check")
- You can use these in R, Python, Julia, Matlab, ...

## Graph of the optimization problem

<img width="450" src="http://earlelab.rit.albany.edu/gallery/LogLVOacac.jpg" alt="Likelihood function">

This is a graph of a likelihood function. The parameters are on the `x` and `y` axes and the likelihood is on the `z` axis.

## How numerical optimization works
- User provides an **objective function** and a **starting value**
- The optimizer then calculates the magnitude and direction of the *gradient vector* at the starting value
- Given these values of the gradient vector, it decides 
    * in which direction to move to get closer to the optimum
    * how far it should move to get closer to the optimum
- Given the magnitude and direction of the gradient vector at the new point, it repeats these steps until convergence is achieved 

## How to determine convergence? (How do we know when we've "arrived"?)
There are generally three ways to determine if a numerical optimization algorithm has reached the optimum
1. The gradient vector (or Jacobian matrix) is numerically close to 0
    - Intuition: we may be at an extremum if the derivative is 0
2. The location of the previous guess is numerically close to the location of the updated guess
    - Intuition: The optimizer didn't move very far in updating the guess, so we're probably close to the answer
3. The value of the objective function at the previous guess is numerically close to the value of the objective function at the updated guess
    - Intuition: The objective function is flat in the area of the previous and updated guesses, which is kind of like having a gradient of zero

Note that "numerically close" generally refers to being within 10^-6


## Local or global minimum?
- Note that in the previous slide, no mention of second-order conditions was ever made
- Hence, it is unclear if the answer our optimizer gave is a local optimum, a saddle point, or a global optimum
- Luckily, most common statistical estimators have been proven to have **globally concave** objective functions
- If you are unsure whether or not your objective function is globally concave, you can try different sets of starting values and see how much the answers differ

*Note:* "globally concave" simply means that the function has only one "hump" or only one "dip" which means we will eventually get to the only extremum.

## Most commonly used optimization algorithms

- Gradient descent
- Stochastic gradient descent
- BFGS/L-BFGS
- Nelder-Mead (gradient-free simplex methods)
- Gauss-Newton 

## When should I use which algorithm?

- It turns out that optimization can often be more of an "art" than a "science"
- Often times your choice of objective function will dictate which optimization algorithm you should choose
- We'll talk more about these considerations a bit later today 

## How to use these in R? 
R has several packages for calling these commonly used optimizers, as well as many others. In a future problem set, you will get experience with the packages `optimr` and `nloptr`.

Sadly, R is not the best language to be using if you need to optimize your own functions. I recommend Python or (especially) Julia!


## Gradient descent
What is gradient descent?

- Pretend you are on a mountain and there's a valley below that you're trying to get to
- There's a fog over the whole mountain, such that you can't see down the mountain
- You want to get down the mountain as quickly as possible
- You have a special compass that will tell you the steepness of the hill in every direction
- It's costly to look at the compass
- You need to decide how often to look at the compass (i.e. how far to walk before checking the compass and potentially changing direction)

The best way down the mountain is to follow the path of steepest descent while taking the minimum number of stops to look at the compass

## The math behind Gradient descent

- Start with some initial value (call it x0) and some step size (call it &gamma;)
- The new guess of the solution is equal to

x_n = x0 - &gamma;&nabla;f(x0)

where &nabla;f(x0) is the gradient vector of our objective function f(&middot;)

Repeat this process until convergence (i.e. until &nabla;f(x0) is arbitrarily close to 0, until x doesn't change across iterations, or until f(x) doesn't change across iterations

## Famous quote
"Victory will never be found by taking the line of least resistance." -- Winston Churchill

- But in actuality, with gradient descent, victory *is* found by taking the line of (steepest descent)!


## Gradient descent in R
Suppose we want to find the minimum of `f(x) = x^4 - 3*x^3 + 2`

```r
# set up a stepsize
alpha <- 0.003

# set up a number of iteration
iter <- 500

# define the gradient of f(x) = x^4 - 3*x^3 + 2
gradient <- function(x) return((4*x^3) - (9*x^2))

# randomly initialize a value to x
set.seed(100)
x <- floor(runif(1)*10)

# create a vector to contain all xs for all steps
x.All <- vector("numeric",iter)

# gradient descent method to find the minimum
for(i in 1:iter){
        x <- x - alpha*gradient(x)
        x.All[i] <- x
        print(x)
}

# print result and plot all xs for every iteration
print(paste("The minimum of f(x) is ", x, sep = ""))
```

## How to write a function in R 
How do you write a function in R? The function has four distinct elements:

1. Name
2. Arguments (aka inputs)
3. Statements (i.e. code)
4. Outputs

```r
myfunction <- function(arg1, arg2, ... ){
statements
return(object)
}
```

Note the braces!

## Calling a function
Once you have your function written, you call it as follows:

```r
output <- myfunction(arg1, arg2, ...)
```

where `output` can be any name you'd like, and `arg1` etc. are the specific arguments you're interested in

## Example of a simple function
```r
customMean <- function(x){
mean <- sum(x)/length(x)
return(mean)
}

# Now let's call the function

sample.average <- customMean(iris$Sepal.Width)
print(sample.average)

# Check that it's correct
mean(iris$Sepal.Width)
```

## Function scope

- It doesn't matter what you name your variables when you call the function
- i.e. when we called `customMean()` above, we sent it `iris$Sepal.Width` even though we called the input `x` in the function definition
- This is all to say that when a function is *evaluated*, its new workspace is whatever is sent to the function
- This is important to keep in mind when trying to optimize your own objective function

<img width="650" src="functionScope.png" alt="Scope of functions">

## Using `nloptr`
Now that we know how to write a function, let's optimize the same function we did before (using gradient descent) but instead now let's use one of the optimizers in the `nloptr` package.

To use the package we need to provide the following information:

- Objective function
- Gradient vector of the objective function
- Algorithm
- Initial value
- Tolerance parameter

## Code
```r
library(nloptr)
## Our objective function
eval_f <- function(x) {
return( x[1]^4 - 3*x[1]^3 + 2 )
}

## Gradient of our objective function
eval_grad_f <- function(x) {
return( 4*x[1]^3 - 9*x[1]^2 )
}

## initial values
x0 <- -5

## Algorithm parameters
opts <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-8)

## Find the optimum!
res <- nloptr( x0=x0,eval_f=eval_f,eval_grad_f=eval_grad_f,opts=opts)
print(res)
```

## Comparison with previous result
As you can see, we got the same result using this method as we did with our simple gradient descent.

## What if my function isn't differentiable?
By now you might be wondering how we can find the optimum of a function that is not differentiable. The answer is to use what's called a "simplex method."

A simplex is a multi-dimensional triangle. Rather than find the "steepest" path, the triangle moves around to find lower spots of the objective function. The triangle can do one of many operations:

- reflect
- expand
- contract
- shrink

The alogrithm uses the ordering of the points of the mutli-dimensional triangle to figure out which operation it should next use in order to find the minimum.

## Nelder-Mead code
```r
library(nloptr)
## Our objective function
objfun <- function(x) {
return( x[1]^4 - 3*x[1]^3 + 2 )
}

## initial values
xstart <- 5

## Algorithm parameters
options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-8)

## Find the optimum!
res <- nloptr( x0=xstart,eval_f=objfun,opts=options)
print(res)
```

## Computing OLS and MLE estimates using the `nloptr` package
Now let's see how we can actually optimize a statistical model using the `nloptr` package in R.

OLS objective function:
```r
library(nloptr)
## Our objective function
objfun <- function(beta,y,X) {
return (sum((y-X%*%beta)^2))
# equivalently, if we want to use matrix algebra:
# return ( crossprod(y-X%*%beta) )
}

## Gradient of our objective function
gradient <- function(beta,y,X) {
return ( as.vector(-2*t(X)%*%(y-X%*%beta)) )
}

## read in the data
y <- iris$Sepal.Length
X <- model.matrix(~Sepal.Width+Petal.Length+Petal.Width+Species,iris)

## initial values
beta0 <- runif(dim(X)[2]) #start at uniform random numbers equal to number of coefficients

## Algorithm parameters
options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e3)

## Optimize!
result <- nloptr( x0=beta0,eval_f=objfun,eval_grad_f=gradient,opts=options,y=y,X=X)
print(result)

## Check solution
print(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris)))
```

## MLE estimation using the `nloptr` package
Now let's estimate the same model, but this time using the MLE formulation of the linear regression model:

MLE objective function:
```r
library(nloptr)
## Our objective function
objfun  <- function(theta,y,X) {
# need to slice our parameter vector into beta and sigma components
beta    <- theta[1:(length(theta)-1)]
sig     <- theta[length(theta)]
# write objective function as *negative* log likelihood (since NLOPT minimizes)
loglike <- -sum( -.5*(log(2*pi*(sig^2)) + ((y-X%*%beta)/sig)^2) ) 
return (loglike)
}

## read in the data
y <- iris$Sepal.Length
X <- model.matrix(~Sepal.Width+Petal.Length+Petal.Width+Species,iris)

## initial values
theta0 <- runif(dim(X)[2]+1) #start at uniform random numbers equal to number of coefficients
theta0 <- append(as.vector(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris))$coefficients[,1]),runif(1))

## Algorithm parameters
options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-6,"maxeval"=1e4)

## Optimize!
result <- nloptr( x0=theta0,eval_f=objfun,opts=options,y=y,X=X)
print(result)
betahat  <- result$solution[1:(length(result$solution)-1)]
sigmahat <- result$solution[length(result$solution)]

## Check solution
print(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris)))
```

## Stochastic gradient descent
**Stochastic gradient descent (SGD)** is the most popular way to optimize a neural network. (What does "stochastic" mean, anyway, and why is it called stochastic gradient descent?)

Recall regular gradient descent (often called *batch gradient descent*):

- Start with some initial value (call it x0) and some step size (call it &gamma;)
- The new guess of the solution is equal to

x_n = x0 - &gamma;&nabla;f(x0)

where &nabla;f(x0) is the gradient vector of our objective function f(&middot;)

Repeat this process until convergence (i.e. until &nabla;f(x0) is arbitrarily close to 0, until x doesn't change across iterations, or until f(x) doesn't change across iterations

## Stochastic gradient descent (continued)
With SGD, we instead update the gradient for *each observation*.

- each iteration now has N updates within it
- we re-shuffle the data between each iteration

## Let's see how it works, using OLS as our objective function.

Batch gradient descent first:
```r
# set up a stepsize
alpha <- 0.00003

# set up a number of iterations
maxiter <- 500000

## Our objective function
objfun <- function(beta,y,X) {
return ( sum((y-X%*%beta)^2) )
}

# define the gradient of our objective function
gradient <- function(beta,y,X) {
return ( as.vector(-2*t(X)%*%(y-X%*%beta)) )
}

## read in the data
y <- iris$Sepal.Length
X <- model.matrix(~Sepal.Width+Petal.Length+Petal.Width+Species,iris)

## initial values
beta <- runif(dim(X)[2]) #start at uniform random numbers equal to number of coefficients

# randomly initialize a value to beta
set.seed(100)

# create a vector to contain all beta's for all steps
beta.All <- matrix("numeric",length(beta),maxiter)

# gradient descent method to find the minimum
iter  <- 1
beta0 <- 0*beta
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-8) {
    beta0 <- beta
    beta <- beta0 - alpha*gradient(beta0,y,X)
    beta.All[,iter] <- beta
    if (iter%%10000==0) {
        print(beta)
    }
    iter <- iter+1
}

# print result and plot all xs for every iteration
print(iter)
print(paste("The minimum of f(beta,y,X) is ", beta, sep = ""))

## Closed-form solution
print(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris)))
```

Now SGD:
```r
# set up a stepsize
alpha <- 0.0003

## Our objective function
objfun <- function(beta,y,X) {
return ( sum((y-X%*%beta)^2) )
}

# define the gradient of our objective function
gradient <- function(beta,y,X) {
return ( as.vector(-2*X%*%(y-t(X)%*%beta)) )
}

## read in the data
y <- iris$Sepal.Length
X <- model.matrix(~Sepal.Width+Petal.Length+Petal.Width+Species,iris)

## initial values
beta <- runif(dim(X)[2]) #start at uniform random numbers equal to number of coefficients

# randomly initialize a value to beta
set.seed(100)

# create a vector to contain all beta's for all steps
beta.All <- matrix("numeric",length(beta),iter)

# stochastic gradient descent method to find the minimum
iter  <- 1
beta0 <- 0*beta
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-12) {
    # Randomly re-order the data
    random <- sample(nrow(X))
    X <- X[random,]
    y <- y[random]
    # Update parameters for each row of data
    for(i in 1:dim(X)[1]){
        beta0 <- beta
        beta <- beta0 - alpha*gradient(beta0,y[i],as.matrix(X[i,]))
        beta.All[,i] <- beta
    }
    alpha <- alpha/1.0005
    if (iter%%1000==0) {
        print(beta)
    }
    iter <- iter+1
}

# print result and plot all xs for every iteration
print(iter)
print(paste("The minimum of f(beta,y,X) is ", beta, sep = ""))

## Closed-form solution
print(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris)))
```

## Why is SGD useful?
Pros:

- much faster (if properly tuned)
- can be parallelized fairly easily
- can be used for streaming data
- randomness in data across observations can help it find global optima
- Gauss-Newton, L-BFGS can't be used for Big Data sets

Cons:

- convergence is more complicated
- slower in R (since loops are awful)
- must slowly decrease `alpha` (the learning rate) to achieve convergence

## Mini-batch gradient descent

- combines batch gradient descent and SGD
- loop over groups of observations (instead of each observation)
- can improve performance

# Cost functions of commonly used algorithms

## Linear regression (least squares)

```r
objfun <- sum((y-X%*%beta)^2) 
objfun <- crossprod(y-X%*%beta)
```

or (if normal MLE):

```r
loglike <- -sum( -.5*(log(2*pi*(sig^2)) + ((Y-X%*%beta)/sig)^2) ) 
```

## Logistic regression (foundation of neural networks)

```r
loglike <- -sum( (y==1)*(log(h(X%*%beta))) + (y==0)*(log(1-h(X%*%beta))) )

where h(X%*%beta) = exp(X%*%beta)/(1+exp(X%*%beta))
```

Note: h is also known as the *sigmoid function* or the *logistic function*

## Classification and Regression Trees (CARTs)

The cost function for a CART is a little more complicated because it is a two-step process:

1. Minimize within-leaf deviation (i.e. want all observations within a leaf to be as similar as possible)
2. Maximize across-leaf deviation (i.e. want each leaf to be as different as possible from all other leaves)

Have to try various cut points (defining leaf boundaries) and see which configuration best satisfies the above criteria

## Naive Bayes (classification or regression)

This is called "naive" because the researcher makes the "naive" assumption that all of the X's are independent. This is a powerful assumption because it significantly reduces the computation cost.

To estimate the model, simply compute the mean and standard deviation of each X variable

Then plug into the pdf of the normal distribution and create predictions of y that satisfy Bayes' rule

## Support Vector Machine (SVM)

The cost function is similar to least squares, except it does not count errors that are sufficiently small:

```r
costfun <- sum(max(0,1-y*(w%*%X))) + lambda/(sum(w^2))
```

where `w` is the support vector which divides the sample space

## Penalizing complexity
As we will discuss in the coming lectures, prediction problems do better the more predictors there are. But we should also penalize complexity. 

The three ways to penalize complexity are:

1. LASSO model (aka L1 regularization) : (absolute value of each additional parameter counts agains the objective function)
2. Ridge model (aka L2 regularization) : (squared value of each additional parameter counts agains the objective function) 
3. Elastic net model: A weighted average of 1. and 2.

To penalize complexity, just add this term to the cost function (if minimizing) or subtract from objective function (if maximizing)

# Helpful resources

* [An overview of gradient descent optimization algorithms](http://ruder.io/optimizing-gradient-descent/)
