# Unsupervised learning
Through the course so far, we have restricted our attention to statistical models where there is an outcome variable Y and explanatory variables X. Such a setting is known as "supervised learning" because the outcome is "supervising" or "teaching" the out-of-sample X's.

In **unsupervised learning** we do not observe Y for any of our training examples. We simply have a data set that contains the features (X matrix). How can we learn anything in this case? What can we infer from patterns in the X's? These are the fundamental questions of unsupervised learning.

## The main algorithms of unsupervised learning
There are a number of approaches that fall under the umbrella of unsupervised learning. They all, broadly speaking, fall under each of these three main approaches:

1. Clustering
    - k-means clustering
    - Expectation-Maximization (EM) algorithm
2. Dimensionality reduction
    - Principal Components Analysis (PCA)
    - Isomap
3. Reinforcement learning

## Clustering
Clustering refers to the idea of finding patterns in the data. The "Hello World" example of this is t-shirt size. Our goal is to, given measurements of people's height and weight in our data (or shoulder and chest measurments), classify what their t-shirt size should be.

### k-means clustering
The goal of k-means clustering is to divide the data into groups that share similar characteristics. Here, "similar" is defined as "belonging to a group with the same centroild (i.e. mean)." How do we quantify that? Well, like k-nearest neighbors, we need to come up with a number `k` beforehand that will tell us the number of clusters.

Our objective function is to minimize the total distance from every point in each of the k clusters to the centroid of that cluster. Like most algorithms, we need to iteratively guess different values of the centroid to figure out the best arrangement of clusters:

* **Step 1:** Pick k random points to be cluster centroids
* **Step 2:** Measure the distance from every point to each of the k centroids. Then we label as "1" each point that is closest to centroid 1, as "2" each point closest to centroid 2, etc.
* **Step 3:** Compute the average X value for each of the points labeled "1", "2", ... "K". Those are the new centroids
* **Step 4:** Repeat steps 2 and 3 until the centroids don't move much between iterations

#### Things to keep in mind when doing k-means
The user should be aware of the following issues when doing k-means clustering:

* The algorithm will only provide a *local optimum* so it behooves the user to try different sets of initial cluster guesses
* The algorithm depends on the X's provided by the user. It's best to keep the dimensionality of X as low as possible, for the same reason that kNN doesn't work well in high dimensions
* What is the optimal number of clusters? Could be determined by some external factor (e.g. we can only make five different sizes of shirts), but is there a statistical way to choose `k`?

If you don't like the Euclidean distance norm, you can do **k-medians clustering** which iteratively uses the median and the 1-norm distance metric, rather than the mean and the 2-norm distance metric. (This difference is exactly the same difference as L1 vs. L2 regularization.)

##### Choosing optimal value of `k`
How do we know what the optimal value of `k` is in this algorithm? It turns out we can do something akin to cross-validation (though it's not quite the same, since cross-validation only applies in supervised learning). 

It turns out that the optimal number of clusters is the number that minimizes the within-cluster sum of squared Euclidean distances (WCSS). [We can think of "distance" as "error" in this case.] Now, this is always decreasing, but the graph of WCSS vs. K typically has an "elbow" which indicates the `k` that is optimal.

#### k-means clustering in R
How to do k-means clustering in R? You can use the `mlr` package (learner `cluster.kmeans`), but you can also just do it in base R (function: `kmeans(X,k)`). For example, let's see if we can use the `iris` dataset to classify the flowers looking only at the petal and sepal information (code taken from [here](http://rischanlab.github.io/Kmeans.html)):

```r
X <- iris[,-5]
Y <- iris[, 5]

clusters <- kmeans(X,3)
clusters
# K-means clustering with 3 clusters of sizes 38, 50, 62
# 
# Cluster means:
#   Sepal.Length Sepal.Width Petal.Length Petal.Width
# 1     6.850000    3.073684     5.742105    2.071053
# 2     5.006000    3.428000     1.462000    0.246000
# 3     5.901613    2.748387     4.393548    1.433871
# 
# Clustering vector:
#   [1] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#  [38] 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
#  [75] 3 3 3 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 3 1 1 1 1 3 1 1 1 1
# [112] 1 1 3 3 1 1 1 1 3 1 3 1 3 1 1 3 3 1 1 1 1 1 3 1 1 1 1 3 1 1 1 3 1 1 1 3 1
# [149] 1 3
# 
# Within cluster sum of squares by cluster:
# [1] 23.87947 15.15100 39.82097
#  (between_SS / total_SS =  88.4 %)

table(Y,clusters$cluster)
# 
# Y             1  2  3
#   setosa      0 50  0
#   versicolor  2  0 48
#   virginica  36  0 14
```

If we chose `k=2` we would get a WCSS (`between / total`) of 77.6% instead of 88.4%. If we chose `k=4` we would get a measure of 89.5%. So the "elbow" is at `k=3`.

A great primer on k-means clustering by Andrew Ng is available [here](https://docs.opencv.org/3.2.0/de/d4d/tutorial_py_kmeans_understanding.html). For an application to the fashion world, see [here](http://blog.fitrrati.com/science-behind-sizes-in-fashion-clustering-size-related-brand-data/). There are great visualizations of the process at both.

### The EM algorithm
The Expectation Maximization (EM) algorithm is a generalization of k-means. It extends the concept of "best" and "similar" to other useful contexts. The most common use of the EM algorithm is in missing data situations. The simplest form is a naive Bayes classification setting where the class labels are unobserved.

#### Quick review of naive Bayes
In the naive Bayes model, we *naively* assume that the joint probability Pr(Y=y, X<sub>1</sub>=x<sub>1</sub>, X<sub>2</sub>=x<sub>2</sub>, ..., X<sub>k</sub>=x<sub>k</sub>) is equal to the product of the marginal probabilities Pr(Y=y) * Pr(X<sub>1</sub>=x<sub>1</sub> | Y=y) * Pr(X<sub>2</sub>=x<sub>2</sub> | Y=y) * ... * Pr(X<sub>k</sub>=x<sub>k</sub> | Y=y).

Our objective is to compute the posterior (or "updated") probability of a given case being labeled as y, after seeing more data (the X's).

##### Prior probability
 Our prior probability is simply the probabity of seeing in the data our target variable Y take on the value y

* Pr(Y=0) = `mean(Y==0)`
* Pr(Y=1) = `mean(Y==1)`

##### Marginal probabilities
The marginal probabilities are naively assumed to be independent of each other. So,

* Pr(X<sub>k</sub>=m | Y=0) = `mean(X[Y==0,k]==m)` if X<sub>k</sub> is discrete
* Pr(X<sub>k</sub>=m | Y=0) = `dnorm(m,mean=mu.k,sd=sd.k)` if X<sub>k</sub> is continuous, where `mu.k = mean(X[Y==0,k])` and `sd.k = sd(X[Y==0,k])`

##### Posterior probability
The posterior probability is then as written above:

Pr(Y=y | X=m) = Pr(Y=y) * Pr(X<sub>1</sub>=x<sub>1</sub> | Y=y) * Pr(X<sub>2</sub>=x<sub>2</sub> | Y=y) * ... * Pr(X<sub>k</sub>=x<sub>k</sub> | Y=y).

recall that, for discrete X's, the information required to calculate the posterior probability can be looked up from a two-way contingency table between Y and each X<sub>k</sub>.

#### Back to the EM
So, the question the EM algorithm seeks to answer is: can we compute posterior probabilities of the naive Bayes classifier even if we don't observe the Y variable? In this way, the EM algorithm, in its simplest case, can be thought of as an unsupervised version of naive Bayes.

It turns out that we can indeed obtain the posterior probabilities, if we follow an iterative two-step algorithm (steps 2-3 below):

1. Start with a guess of the unobserved class probability for each training example, e.g. Pr(Y=y | X<sub>i</sub>)
2. Using the information in the previous step, update your guess of the prior probabilities Pr(Y=y) and marginals Pr(X=x | Y=y)
3. Given the updated information, compute the posterior probabilities of belonging to each (unobserved) class, using Bayes Rule
4. Repeat steps 2-3 until convergence in the posterior probabilities across iterations

##### EM steps in detail
**Step 1:** Simply initialize Pr(Y=y) for each y and each training example. Probabilities must be non-negative and sum to 1. Denote these probabilities q<sub>ic</sub>.

**Step 2:** Update prior and marginals.

*Prior probability*
Instead of `mean(Y==0)` we compute Pr(Y=0) as the average of the q<sub>ic</sub> values

* e.g. `mean(q0)`

*Marginal probabilities*
For the marginals, we can't subset on values of Y (since we don't observe them), so we instead compute *probabilistic* values like so:

* Pr(X<sub>k</sub>=m | Y=0) = `wtd.mean(X[ ,k]==m,q0)` if X<sub>k</sub> is discrete
* Pr(X<sub>k</sub>=m | Y=0) = `dnorm(m,mean=mu.k,sd=sd.k)` if X<sub>k</sub> is continuous, where `mu.k = wtd.mean(X[ ,k],q0)` and `sd.k = wtd.sd(X[ ,k],q0)`

**Step 3:** Update posterior probabilities q<sub>ic</sub>. Once we have the prior and the marginals computed, we apply the Bayes Rule formula to get the updated values of q<sub>ic</sub>.

**Step 4:** Repeat Step 2 and Step 3 until convergence in the q<sub>ic</sub>'s.

#### More general applications of the EM algorithm
Naive Bayes is the simplest form of the EM algorithm, but the true power behind it is that it can be used for any likelihood-based model. In my research, I use the EM alogrithm to detect unobserved types of individuals, using information on choices they've made, wages they earn, and other measures (like test scores).

#### Simple EM algorithm example in R
Let's repeat our example that we did with the k-means clustering but this time with the EM algorithm. The package `mclust` does all of the work for us, but it will only work for X matrices that are continuous.

```r
library(mclust)
X <- iris[,-5]
Y <- iris[, 5]

clusters <- Mclust(X,G=3)

clusters$parameters$pro # list posterior probabilities of Pr(Y=y)
# [1] 0.3333333 0.3005423 0.3661243

table(Y) # list frequencies of each species in iris data
# Y
#     setosa versicolor  virginica 
#         50         50         50 

clusters$parameters$mean # list average of X's conditional on being in class y
#               [,1]     [,2]     [,3]
# Sepal.Length 5.006 5.915044 6.546807
# Sepal.Width  3.428 2.777451 2.949613
# Petal.Length 1.462 4.204002 5.482252
# Petal.Width  0.246 1.298935 1.985523

head(clusters$z) # list posterior class probabilities for each observation in our training data
#      [,1]         [,2]         [,3]
# [1,]    1 4.916819e-40 3.345948e-29
# [2,]    1 5.846760e-29 1.599452e-23
# [3,]    1 2.486168e-33 2.724243e-25
# [4,]    1 2.050996e-28 2.180764e-22
# [5,]    1 8.283066e-42 8.710458e-30
# [6,]    1 2.118466e-41 1.791499e-29

table(Y,clusters$classification) # compare EM classes with actual classes
# 
# Y             1  2  3
#   setosa     50  0  0
#   versicolor  0 45  5
#   virginica   0  0 50
```

It does a better job of finding the species than does k-means!

## Dimensionality reduction
Aside from clustering, another branch of unsupervised learning is **dimensionality reduction** which simply means that there may be a way to simplify our data while preserving almost all of the variation among our variables.

### Principal-component analysis (PCA)

> "PCA is to unsupervised learning what linear regression is to the supervised variety." -- Pedro Domingos, *The Master Algorithm* p. 214.

As alluded in the quote above, PCA is the workhorse algorithm of dimensionality reduction, and probably the most popular unsupervised learning algorithm out there.

#### Intuition
The idea behind PCA is that we can preserve the "picture" of our data by removing multiple columns and adjusting the remaining columns accordingly. To visualize this, see [here](http://setosa.io/ev/principal-component-analysis/). Intuitively, if X and Y are highly correlated, then we don't have to worry about analyzing both of them; we can look at either X or Y alone.

#### Math
The math behind PCA is based on **eigen values** of a linear transformation of our data. Eigen values are basically numbers -- unique to our data -- that tell us which variables can be dropped, and in which ways the rest of our variables need to be transformed to preserve the variation in the data.

* Why do we care about the matrix X<sup>'</sup>X? Because it's what holds the variation in our data. (And because eigen values require a square matrix.)
* Why do we need eigen values? Because they tell us how to transform our data to preserve the variation. 

The eigen vector of linear transformation matrix A is the vector &lambda; that satisfies

Ax = &lambda;Ix

or

(A-&lambda;I)x = 0

The elements of the vector &lambda; are known as **eigen values**, or characteristic roots, of the linear transformation A.

* The linear transformation we are interested in is a rotation of our data such that one of our variables vanishes.

As a side note, there is an alternative way to get the eigen values of the transformation which is called **Singular Value Decomposition (SVD)** which you might hear about. It's a slightly different method to get to the same answer.

#### Uses of PCA
PCA is quite useful, particularly in the following areas:

* Text analysis (text meaning)
* Image recognition (facial expressions -- see also [Eigenfaces](https://en.wikipedia.org/wiki/Eigenface))
* Recommender systems (compress clicks and likes into "tastes")
* Many others

#### Pros and Cons of PCA

* Pros
    - Fairly easy to compute
    - Intuitive
    - Massively popular
* Cons
    - New variables are much less interpretable
    - Restricted to linear transformations
    - May not improve performance of a classification or regression task, since there may be nonlinear relationships that PCA will destroy

#### How to do PCA in R
There are many possible ways to do PCA in R. For today, we will use the `princomp` function included in base R.

First, we will do the computation "brute force" and then we will use the built-in function which automates a lot of the process for us.

```r
# computing eigen values of correlation matrix
cormat <- X %>% cor(.)
print(cormat)
#              Sepal.Length Sepal.Width Petal.Length Petal.Width
# Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
# Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
# Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
# Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000

print(eigen(cormat)$values)
# [1] 2.91849782 0.91403047 0.14675688 0.02071484

# compute eigen vectors
v <- eigen(cormat)$vectors
#            [,1]        [,2]       [,3]       [,4]
# [1,]  0.5210659 -0.37741762  0.7195664  0.2612863
# [2,] -0.2693474 -0.92329566 -0.2443818 -0.1235096
# [3,]  0.5804131 -0.02449161 -0.1421264 -0.8014492
# [4,]  0.5648565 -0.06694199 -0.6342727  0.5235971

print(crossprod(v)) # should be identity matrix
#               [,1]          [,2]          [,3]          [,4]
# [1,]  1.000000e+00  1.316246e-16 -6.015309e-17  3.731518e-17
# [2,]  1.316246e-16  1.000000e+00 -1.138979e-16  4.413915e-17
# [3,] -6.015309e-17 -1.138979e-16  1.000000e+00 -1.679304e-16
# [4,]  3.731518e-17  4.413915e-17 -1.679304e-16  1.000000e+00

# do PCA using base R function prcomp. this function automatically scales the data for you
prin.comp <- prcomp(X, scale. = T)

# show eigen vectors (will be same as v)
print(prin.comp$rotation)
# Rotation (n x k) = (4 x 4):
#                     PC1         PC2        PC3        PC4
# Sepal.Length  0.5210659 -0.37741762  0.7195664  0.2612863
# Sepal.Width  -0.2693474 -0.92329566 -0.2443818 -0.1235096
# Petal.Length  0.5804131 -0.02449161 -0.1421264 -0.8014492
# Petal.Width   0.5648565 -0.06694199 -0.6342727  0.5235971

# show eigen values
print(prin.comp$sdev^2)
# Standard deviations (1, .., p=4):
# [1] 2.91849782 0.91403047 0.14675688 0.02071484

# which components explain the most variance?
prop.var.explained <- prin.comp$sdev^2/sum(prin.comp$sdev^2)
print(prop.var.explained)
# [1] 0.729624454 0.228507618 0.036689219 0.005178709

# keep only the first three components (since these explain 99.5% of the variance)
reducedX <- prin.comp$x[,-4]
```

### Isomap: Dimensionality reduction for nonlinear relationships
PCA is great, but only works well for relationships that are linear. As an example, *The Master Algorithm* discusses finding the principal component of latitude and longitude of cities along San Francisco Bay -- from San Francisco, moving southeast to San Jose, then moving northwest to Oakland. These cities are all more or less on the same road (see picture below)

![Source: Google Maps](../Graphics/bayCities.png "Bay-Area Cities")

If we use PCA in this example, it will draw a line right down the middle of SF bay, which will no be useful for us. The true level of dimension reduction would have us express the distance from San Francisco along the one major road. It just so happens that that road is non-linear, so PCA won't be of much help to us.

**Isometric Feature Mapping (Isomap)** provides a way to do non-linear dimension reduction.

#### How Isomap works
Isomap is built on the k-nearest neighbor principle. Each data point is linked to its k-nearest neighbors and the distance between them is recorded. Then, Isomap finds a reduced set of coordinates that best preserves the distances between nodes (groups of k-nearest neighbors).

#### Pros and Cons of Isomap
* Pros
    - Works well if relationships in the data are not *too* nonlinear
* Cons
    - In many cases will not outperform PCA (see [here](http://www.whuang.org/papers/whuang2012_ivc.pdf))
    - More vulnerable to outliers and other abnormalities of the data

#### Using Isomap in R

```r
library(RDRToolbox)

isomapped <- Isomap(data=as.matrix(X), dims=3, k=5)
XreducedNL <- isomapped$dim3
```

You can then do analysis on the non-linearly reduced data as you would anything else.

### Other resources
There are many other non-linear dimensionality reduction methods, see [here](https://en.wikipedia.org/wiki/Nonlinear_dimensionality_reduction) for a complete list. Most popular are:

- Kernel PCA (where we apply a nonlinear function to our data before doing PCA)
- Local-linear embedding (LLE) which operates similarly to Isomap, but may have different properties

## Reinforcement learning
**Reinforcement learning** provides a framework by which computers can learn strategies in games. This presents a more general definition of the word "learn" than we have been talking about in this course (we've mainly focused on out-of-sample prediction as "learning").

The reinforcement learning framework has its roots in optimal control theory (think: optimal stopping problem) and is composed of the following:

* an agent
* an environment
* a set of actions that the agent can perform (e.g. move bishop 3 spaces)
* states of the world (e.g. set of spaces agent can move to; set of spaces occupied by opponent)
* reward (e.g. win / lose)
* rules specific to the task being performed

The goal of the algorithm is to maximize the reward.

### Example: chess
In chess:

* **reward:** only comes at the end of the game: +1 for a win, 0 for a draw, -1 for a loss. The agent is one of the players, and the en
* **agent:** one of the players
* **environment:** chess board, rules of the game
* **set of actions:** all possible moves available to the agent when it is her turn
* **states:** the current position of all pieces on the board; the number of moves that have already taken place; etc.

- Because the reward only comes at the end of the game, the algorithm may need to make "now-for-later" choices that appear to be costly, but in actuality result in a higher likelihood of reward. The agent may need to discount the future reward by some amount when deciding which action to take because the reward only happens at the very end.
- Put another way, the agent may be better off assigning some amount of **expected reward** to each possible action and maximizing that. (In the chess example, you can think of "one move away from checkmate" as having a 100% likelihood of reward, "two moves away from checkmate" as also having a high reward, etc.)

### Solving a reinforcement learning problem
How does one actually *solve* a reinforcement learning problem? Following up on the previous note about working backwards from the reward, reinforcement learning problems are best solved by working backward from the reward and choosing the actions that yield highest expected value.

There are advanced mathematical techniques that simplify the number of states that need to be visited to find the path of maximum reward, but we won't cover these in this class. If you're curious, Google "Bellman Equation."

There is also a lesson in life from this, in the following quote by S&oslash;ren Kierkegaard:
> Life can only be understood backwards; but it must be lived forwards

### Example: going to college
Each of you has made a decision to attend college and enroll in the Master's program. Why did you do it? Because your expected reward from doing so exceeds your expected reward from not doing so. In living your life, you have begun solving your own reinforcement learning problem.

The same logic applies to 

### Other applications
Reinforcement learning most naturally applies to any game of strategy. AlphaGo and AlphaZero employ reinforcement learning to build world-beating Go and Chess bots. In sports, teams can figure out better strategies and play-calling by engaging in reinforcement learning (though I'm not sure how often they actually do this!). For example, the "3-point revolution" in the NBA came about because some teams realized that 3 points is more than 2 so that the expected reward can be greatly increased by attempting (and practicing) more 3-point shots.

### Exploration-Exploitation
Along with reinforcement learning, you'll also hear something called the "exploration-exploitation tradeoff." This simply means that, by taking actions you know to be the highest-reward, you may be leaving left untaken actions that could lead to an even *higher* reward. Thus, the optimal strategy is to randomly deviate from the observed best path and further "explore" the state space (rather than continuing to "exploit" the states that you know about).

The exploration-exploitation tradeoff also has many applications to real life AI development. It has been used to get robots to:

* self-driving cars
* balance poles
* manage automated telephone dialogues
* many, many others

Many of our day-to-day activities are also the result of our human brain's innate ability to engage in reinforcement learning.

# Useful links
* Nice [intro](https://docs.opencv.org/3.2.0/de/d4d/tutorial_py_kmeans_understanding.html) to k-means clustering
* Technical [writeup](http://www.cs.columbia.edu/~mcollins/em.pdf) of EM algorithm for naive Bayes classification
* Great [summary of PCA](https://towardsdatascience.com/a-one-stop-shop-for-principal-component-analysis-5582fb7e0a9c) from the *Towards Data Science* blog
* More detailed [summary](https://www.analyticsvidhya.com/blog/2016/03/practical-guide-principal-component-analysis-python/) of how to do PCA in R and Python
* Installation [instructions](https://rdrr.io/bioc/RDRToolbox/) for the `RDRToolbox` package (not available on CRAN)
* [R script](https://github.com/tyleransom/DScourseS18/blob/master/MachineLearning/unsupervisedExamples.R) with all of the code contained in these notes
