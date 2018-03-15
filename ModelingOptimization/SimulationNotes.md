# Some notes on simulation and its link with optimization & data science
These notes introduce the concept of *simulation* as a potentially useful tool in a data scientist's belt.

## What is simulation?
Simulation can mean a lot of different things, depending on the discipline. 

1. As it relates to our previous discussions, **simulation has a close relationship with optimization**. That is, some objective functions are better solved by simulation than by gradient descent or other optimization algorithms. (Note: we won't cover any of these in this class)

2. **Simulation can be a useful tool for debugging**. Suppose you have a statistical model, and you're not quite sure what the answer should be. You can generate fake data (in which you know all of the parameters of interest) and can use that fake data to make sure that you haven't made any mistakes. This is the context we will be discussing today.

## The Monte Carlo method
"Monte Carlo methods (or Monte Carlo experiments) are a broad class of computational algorithms that rely on repeated random sampling to obtain numerical results." -- [Wikipedia](https://en.wikipedia.org/wiki/Monte_Carlo_method)

**Why is it called "Monte Carlo"?**
* *Monte Carlo* is a phrase coined by John von Neumann while working on the Manhattan Project.
    * (Monte Carlo is the name of the casino in Monaco where the uncle of von Neumann's co-worker, Stanisław Ulam, would borrow money to gamble)
    * It was a code name for Ulam and von Neumann's early use of what we now call the Monte Carlo method

### Example
What are the odds of being dealt a flush in 5-card poker? There are two avenues to computing this:

1. Use combinatorics (i.e. combinations and permuations ... "n Choose r") to analytically solve for the probability
2. Shuffle the deck and deal the cards 100,000 times and count the number of times a flush happens

(2) is known as the "Monte Carlo method"

In sports: "If the Cavs and Warriors had played that game 10 times, the Warriors would have won 9 of them." This type of discussion implictly appeals to the Monte Carlo method (though 10 is almost never a reasonable sample size!)

Nowadays with computing getting cheaper and cheaper, it's often easier to solve problems via simulation than going through the analytical derivation.

## The Data Scientist's Lab
Monte Carlo (or, equivalently, Simulation) can be thought of as "the data scientist's lab" because it's a way to discover new methods and test the properties of existing methods.

How to do this? Let's go through a simple example.

## Simulate the classical linear model
What's the "Hello world" of optimization? The classical linear model!

```r
y <- X%*%beta + epsilon
```

## Steps to the simulation
Here's what we need to do the simulation:

0. Random number seed (to be able to replicate random draws)
1. Sample size (`N`)
2. Number of covariates (`K`)
3. Covariate matrix (`X`), which is N by K
4. Parameter vector (`beta`) which matches the size of `X`
5. Distribution of &epsilon; (e.g. N(0,sigma^2))

Steps to create the data:

```r
set.seed(100)
N <- 100000
K <- 10
sigma <- 0.5

X <- matrix(rnorm(N*K,mean=0,sd=sigma),N,K)
X[,1] <- 1 # first column of X should be all ones
eps <- rnorm(N,mean=0,sd=0.5)
betaTrue <- as.vector(runif(K))
Y <- X%*%betaTrue + eps
```

Now we have some fake data that follows our **data generating process**

## Evaluating the simulation
We can now evaluate our simulation by, e.g. running 

```r
estimates <- lm(Y~X -1)
print(summary(estimates))
```

and we should get something very close to `betaTrue` as our estimates

The estimates won't be exactly equal to `betaTrue` unless we have `N <- infinity`. This is because of randomness in our &epsilon;.

