# PS8
#Erik Fretland
#3/26/18


install.packages('nloptr')
install.packages('tibble')
library(nloptr)
library(tibble)

set.seed(100)

X <- matrix(rnorm(9*100000),ncol = 9)

X <- as.data.frame(X)

attach(X)

X <- add_column(X, V0 = 1, .before = 1)

colnames(X) <- c("1", "2", "3", "4","5","6","7","8","9","10")

eps <- rnorm(100000, mean = 0, sd = 0.5)

eps <- as.vector(eps)

beta <- c(1.5, -1, -0.25, 0.75, 3.5, -2, 0.5, 1, 1.25, 2)

Y <- (X*beta + eps)

Y <- c(t(Y))

#Question 5

## Create X and Y matrices for this specific regression
X <- as.matrix(X)
Y <- as.matrix(Y)

## Choose beta-hat to minimize the sum of squared residuals
## resulting in matrix of estimated coefficients:
bh <- round(solve(t(X)%*%X)%*%t(X)%*%Y, digits=2)

## Label and organize results into a data frame
beta.hat <- as.data.frame(cbind(c("Intercept","IV"),bh))
names(beta.hat) <- c("Coeff.","Est")
beta.hat


## Calculate vector of residuals
res <- as.matrix(Y-bh[1]-bh[2]*X)

## Define n and k parameters
n <- nrow(Y)
k <- ncol(X)

## Calculate Variance-Covariance Matrix
VCV <- 1/(n-k) * as.numeric(t(res)%*%res) * solve(t(X)%*%X)

## Standard errors of the estimated coefficients
StdErr <- sqrt(diag(VCV))

## Calculate p-value for a t-test of coefficient significance
P.Value <- rbind(2*pt(abs(bh[1]/StdErr[1]), df=n-k,lower.tail= FALSE),
                2*pt(abs(bh[2]/StdErr[2]), df=n-k,lower.tail= FALSE))

## concatenate into a single data.frame
beta.hat <- cbind(beta.hat,StdErr,P.Value)
beta.hat




#Question 6

# set up a stepsize
alpha <- 0.0000003

# set up a number of iterations
maxiter <- 500000

## Our objective function
objfun <- function(beta,Y,X) {
  return ( sum((Y-X%*%beta)^2) )
}

# define the gradient of our objective function
gradient <- function(beta,Y,X) {
  return ( as.vector(-2*t(X)%*%(Y-X%*%beta)) )
}



# create a vector to contain all beta's for all steps
beta.All <- matrix("numeric",length(beta),maxiter)

# gradient descent method to find the minimum
iter  <- 1
beta0 <- 0*beta
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-8) {
  beta0 <- beta
  beta <- beta0 - alpha*gradient(beta0,Y,X)
  beta.All[,iter] <- beta
  if (iter%%10000==0) {
    print(beta)
  }
  iter <- iter+1
}



## Closed-form solution
Ydf <- as.data.frame(Y)
print(summary(lm(Y~X,data=Ydf)))



#Question 7

# nloptr's L-BFGS algorithm

objfun7a <- function(beta,Y,X) {
  return (sum((Y-X%*%beta)^2))
}

## Gradient of our objective function
gradient <- function(beta,Y,X) {
  return ( as.vector(-2*t(X)%*%(Y-X%*%beta)) )
}






## Algorithm parameters
options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e3)

## Optimize!
result <- nloptr( x0=beta0,eval_f=objfun7a,eval_grad_f=gradient,opts=options,Y=Y,X=X)
print(result)


#Question 9

regression <- lm(Y ~ X -1, data= Ydf)
summary(regression)

library(stargazer)

stargazer(regression)
