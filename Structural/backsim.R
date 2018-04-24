library(nloptr)

set.seed(100)

# Generate some data
N <- 10000
T <- 2
J <- 2
#beta <- 0
beta <- 0.95
age0 <- sample(1:10,N,replace=T)
age <- matrix(0, N, T)
for (t in 1:T) {
    age[ ,t] <- age0+t-1
}
LY <- sample(1:J,N,replace=T)

# true parameters
alpha <- c(1.5,-0.25,-1)

# fill in utility
u1 <- matrix(0, N, T)
u2 <- matrix(0, N, T)
for (t in 1:T) {
    u1[ ,t] <- 0*age[ ,t]
    u2[ ,t] <- alpha[1] + alpha[2]*age[ ,t]
}

# compute choice probabilities and draw state-contingent choices
a  <- alpha[3]*(1-diag(J))
#a[1,2] <- 0
#print(a)
fv <- array(rep(0,N*J*(T+1)),c(N,J,T+1))
Y  <- array(rep(0,N*J*T),c(N,J,T))

for (t in T:1) {
    for (j in 1:J) {
        # Generate FV
        dem <- exp(u1[ ,t] + a[1,j]+fv[ ,1,t+1])+
               exp(u2[ ,t] + a[2,j]+fv[ ,2,t+1])
        fv[ ,j,t] <- beta*(log(dem)-digamma(1))
        p1 <- exp(u1[ ,t] + a[1,j] + fv[ ,1,t+1])/dem
        p2 <- exp(u2[ ,t] + a[2,j] + fv[ ,2,t+1])/dem
        
        # Draw choices
        draw <- runif(N)
        Y[ ,j,t] <- (draw<p1+p2)+(draw<p2)
    }
}

# now create actual choices
Choice <- matrix(0, N, T)
LY1    <- LY
for (t in 1:T) {
    for (j in 1:J) {
        Choice[ ,t] <- Choice[ ,t]+(LY1==j)*Y[ ,j,t]
    }
    LY1 <- Choice[ ,t]
}

LY <- cbind(LY,Choice[ ,1:T-1])

# Now estimate (static model):
easydf <- data.frame(Choice = as.vector(Choice), age = as.vector(age), LY = as.vector(LY))
easydf$switch <- easydf$Choice!=easydf$LY
easydf$switch21 <- easydf$Choice==1 & easydf$LY==2
easydf$switch12 <- easydf$Choice==2 & easydf$LY==1
easydf$switchAny <- easydf$switch21 | easydf$switch12
easydf$Choice <- as.factor(easydf$Choice)

easydfest <- glm(Choice ~ age + switch21, family=binomial(link='logit'), data=easydf)
print(easydfest)

# Now estimate dynamic model (must use nloptr)

objfun <- function(alpha,Choice,age) {
    J <- 2
    a  <- alpha[3]*(1-diag(J))
    
    u1 <- matrix(0, N, T)
    u2 <- matrix(0, N, T)
    for (t in 1:T) {
        u1[ ,t] <- 0*age[ ,t]
        u2[ ,t] <- alpha[1] + alpha[2]*age[ ,t]
    }
    
    Like <- 0
    for (t in T:1) {
        for (j in 1:J) {
            # Generate FV
            dem <- exp(u1[ ,t] + a[1,j]+fv[ ,1,t+1])+
                   exp(u2[ ,t] + a[2,j]+fv[ ,2,t+1])
            fv[ ,j,t] <- beta*(log(dem)-digamma(1))
            p1 <- exp(u1[ ,t] + a[1,j] + fv[ ,1,t+1])/dem
            p2 <- exp(u2[ ,t] + a[2,j] + fv[ ,2,t+1])/dem
            Like <- Like - (LY[ ,t]==j)*((Choice[ ,t]==1)*log(p1)+(Choice[ ,2]==2)*log(p2))
        }
    }
    return ( sum(Like) )
}

## initial values
theta0 <- runif(3) #start at uniform random numbers equal to number of coefficients

## Algorithm parameters
options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-6,"maxeval"=1e4)

## Optimize!
result <- nloptr( x0=theta0,eval_f=objfun,opts=options,Choice=Choice,age=age)
print(result)


### Refresher on using nloptr to estimate a binary logit model

# iris example
df <- iris
df$dummer <- df$Species=="setosa"
df$dummer <- as.factor(df$dummer)
easyway <- glm(dummer ~ Sepal.Width, family=binomial(link='logit'), data=df)

objfun <- function(beta,y,X) {
    return ( -sum((y==TRUE)*X%*%beta-log(1+exp(X%*%beta))) )
    # equivalently, if we want to use matrix algebra:
    # return ( crossprod(y-X%*%beta) )
}

## read in the data
y <- df$dummer
X <- model.matrix(~Sepal.Width,df)

## initial values
theta0 <- runif(dim(X)[2]) #start at uniform random numbers equal to number of coefficients

## Algorithm parameters
options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-6,"maxeval"=1e4)

## Optimize!
result <- nloptr( x0=theta0,eval_f=objfun,opts=options,y=y,X=X)
print(result)
betahat  <- result$solution
