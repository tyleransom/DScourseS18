# Basics for coding optimization problems
This document will give the reader an introduction to numerical optimization and the various trade-offs associated with the most common optimization algorithms. We will also cover how to code and evaluate an optimization problem in R.

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

Note that "numerically close" generally refers to being within 10^-6^


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
- Nelder-Mead
- Gauss-Newton 


