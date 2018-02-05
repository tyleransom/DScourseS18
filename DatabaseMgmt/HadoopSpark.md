# 1. Hadoop and Spark

## 1.1 What is Hadoop?
Hadoop is a *distributed file system* created by Apache Software Foundation (a not-for-profit open-source software provider) that allows for efficient processing of big data sets by distributing data processing computations across a cluster of computers.

Hadoop was created to be 

- **open source**
- **scalable**
- **fault tolerant**

The Hadoop framework is comprised of the following elements:

- *Hadoop Common* -- the base set of libraries
- *Hadoop Distributed File System (HDFS)* -- file system that stores data on many machines
- *Hadoop YARN* -- resource manager for Hadoop jobs ("YARN" stands for "Yet Another Resource Negotiator")
- *Hadoop MapReduce* -- an implementation of the MapReduce programming model for large-scale data processing

### 1.1.1 What is MapReduce?
"MapReduce" is a general programming model for distributing complex or intensive computations across multiple machines.

The main workflow of the MapReduce model is:

1. Split -- divide your huge dataset into K chunks, where K is the number of machines you'll run it on
2. Map -- apply some function to each of the chunked-up datasets (e.g. count words)
    * Other functions such as shuffling and sorting may also take place in the "map" phase 
3. Reduce -- reduce the number of chunks in the dataset by combining chunks either by merging the datasets back together, or performing some other aggregating operation (like addition)

 The following images hopefully illustrate the concept:

![MapReduce1](../Graphics/mapreduce_work.jpg)

![MapReduce1](../Graphics/marylittlelamb_mapreduce.png)

### 1.1.2 Other Apache products
In addition to the above four elements of the Hadoop framework, Apache has continued to create higher-level programs for a more tailored Big Data experience. The most common of these are:

- Pig -- a SQL-style language for MapReduce tasks (think of it as a SQL-style shell scripting language for MapReduce)
- Hive -- a SQL-style interface to query data stored in the HDFS
- Spark -- an innovation on Hadoop MapReduce that relaxes some constraints on how MapReduce jobs must be structured

All of the Apache products work in the HDFS environment.

**Trivia:** Hadoop was created in 2006 following the original MapReduce programming model and the original Google File System, both of which were created by Google in the early 2000s.

## 1.2 What is Spark?


# Useful links

* [Quora: Hadoop vs. Spark](https://www.quora.com/What-is-the-difference-between-Hadoop-and-Spark)
* [Spark workshop slides](https://stanford.edu/~rezab/sparkclass/slides/itas_workshop.pdf)
* [Hadoop wikipedia page](https://en.wikipedia.org/wiki/Apache_Hadoop)
* [MapReduce wikipedia page](https://en.wikipedia.org/wiki/MapReduce)
