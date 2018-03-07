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
- Some estimators (e.g. OLS, GMM) have **closed form** solutions for the extremum value
    * we covered this in our previous lecture
- Other estimators (e.g. MLE, some NLLS) require **numerical methods** to find the extremum value
    * we also showed this in the previous lecture (the case of logistic regression)
- There are a number of different algorithms to numerically find extrema
- You can use these in R, Python, Julia, Matlab, ...

## Graph of the optimization problem

<img width="450" src="http://earlelab.rit.albany.edu/gallery/LogLVOacac.jpg" alt="Likelihood function">


