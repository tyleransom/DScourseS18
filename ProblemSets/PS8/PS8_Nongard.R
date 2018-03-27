#Alex Nongard
#PS8

library(nloptr)
library(stargazer)
set.seed(100)

#4
X<-as.matrix(replicate(10,rnorm(100000)))
X[,1]<-1

eps<-rnorm(100000,0,.25)
beta<-c(1.5, -1, -.25, .75, 3.5, -2, .5, 1, 1.25, 2)

Y<-X%*%beta + eps

#5 - closed form solution

olsest<- solve(t(X) %*% X) %*% t(X) %*% Y




#6 - Gradient Descent
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




#7 - L-BFGS/Nelder-Mead
#L-BFGS
## Our objective function
objfun <- function(beta,Y,X) {
  return (sum((Y-X%*%beta)^2))
  # equivalently, if we want to use matrix algebra:
  # return ( crossprod(y-X%*%beta) )
}

## Gradient of our objective function
gradient <- function(beta,Y,X) {
  return ( as.vector(-2*t(X)%*%(Y-X%*%beta)) )
}


## initial values
beta0 <- runif(dim(X)[2]) #start at uniform random numbers equal to number of coefficients

## Algorithm parameters
options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e3)

## Optimize!
resultlbfgs <- nloptr( x0=beta0,eval_f=objfun,eval_grad_f=gradient,opts=options,Y=Y,X=X)
print(resultlbfgs)



#Nelder-Mead

## Algorithm parameters
options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-6,"maxeval"=1e3)

## Optimize!
resultnm <- nloptr( x0=beta0,eval_f=objfun,eval_grad_f=gradient,opts=options,Y=Y,X=X)
print(resultnm)




#8 - MLE L-BFGS - I cannot get this to work. 
## Our objective function
#  objfun  <- function(theta,y,X) {
#  need to slice our parameter vector into beta and sigma components
#  beta    <- theta[1:(length(theta)-1)]
#  sig     <- theta[length(theta)]
#  write objective function as *negative* log likelihood (since NLOPT minimizes)
#  loglike <- -sum( -.5*(log(2*pi*(sig^2)) + ((y-X%*%beta)/sig)^2) ) 
#  return (loglike)
#}




## initial values
#theta <- runif(dim(X)[2]+1) #start at uniform random numbers equal to number of coefficients
#theta0 <- append(as.vector(summary(lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width+Species,data=iris))$coefficients[,1]),runif(1))

#gradient <- function(theta,Y,X) {
#  grad <- as.vector(rep(0,length(theta)))
#  beta <- theta[1:length(theta)-1]
#  sig <- theta[length(theta)]
#  grad[1:(length(theta)-1)] <- -t(X)%*%(Y-X%*%beta)/(sig^2)
#  grad[length(theta)] <- dim(X)[1]/sig - crossprod(Y-X%*%beta)/(sig^3)
#  return(grad)
#}

#evf<-gradient(theta,Y,X)

  ## Algorithm parameters
#options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e4)

## Optimize!
#result <- nloptr( x0=theta0,eval_f=gradient,opts=options,Y=Y,X=X)
#print(result)
#betahat  <- result$solution[1:(length(result$solution)-1)]
#sigmahat <- result$solution[length(result$solution)]



#9.
easyOLS<- lm(Y~X -1)
stargazer(easyOLS)


