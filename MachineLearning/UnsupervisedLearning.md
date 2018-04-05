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
The Expectation Maximization (EM) algorithm is a generalization of k-means. It extends the concept of "best" and "similar" to other useful contexts. For example, one can use the EM algorithm to fill in missing data using likelihood-based statistical models. In my research, I use the EM alogrithm to detect unobserved types of individuals, using information on choices they've made, wages they earn, and test scores.

The EM algorithm, like k-means is a sequential algorithm. In the first step, the user computes the probability of being in a given cluster. Then in the second step, the user updates the parameters of the model based on the probability given in the first step, and repeats until the cluster probabilities are stable.
