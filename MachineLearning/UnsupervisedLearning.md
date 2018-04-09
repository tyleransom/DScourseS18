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

```
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
3. Given the updated information, compute unobserved class probabilities using Bayes Rule
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

```
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
