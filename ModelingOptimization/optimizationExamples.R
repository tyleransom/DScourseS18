library(nloptr)

#----------------------------------
# OLS estimation with L-BFGS
#----------------------------------

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



#----------------------------------
# MLE estimation with Nelder Mead
#----------------------------------

## Our objective function
objfun  <- function(theta,y,X) {
# need to slice our parameter vector into beta and sigma components
beta    <- theta[1:(length(theta)-1)]
sig   <- theta[length(theta)]
# write objective function as *negative* log likelihood (since NLOPT minimizes)
# loglike <- -sum(dnorm(y-X%*%beta, 0, sig, log=TRUE)) # this might seem tempting, but it doesn't work very well
loglike <- -sum(-.5*(log(2*pi*(sig^2)) + (crossprod(y-X%*%beta))/(sig^2)))
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



#----------------------------------
# Batch gradient descent with OLS
#----------------------------------

# set up a stepsize
alpha <- 0.00003

# set up a number of iterations
iter <- 5000

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
beta.All <- matrix("numeric",length(beta),iter)

# gradient descent method to find the minimum
iter  <- 1
beta0 <- 0*beta0
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-8) {
    beta0 <- beta
    beta <- beta0 - alpha*gradient(beta,y,X)
    beta.All[,i] <- beta
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

#----------------------------------
# Stochastic gradient descent with OLS
#----------------------------------

# set up a stepsize
alpha <- 0.00003

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
beta0 <- 0*beta0
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-10) {
    # Randomly re-order the data
    random <- sample(nrow(X))
    X <- X[random,]
    y <- y[random]
    # Update parameters for each row of data
    for(i in 1:dim(X)[1]){
        beta0 <- beta
        beta <- beta0 - alpha*gradient(beta,y[i],as.matrix(X[i,]))
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




