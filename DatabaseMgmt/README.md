# Data science toolbox
These notes cover a broad view of tools that are required in the data science pipeline.

## 1. Measurement
A large part of data science (and quantitative research in general) is measurement. Measurement is how "insights" or "policies" are constructed, because one cannot construct a policy without first measuring what the policy is meant to accomplish. 

For example, suppose that a basketball coach is trying to find the lineup that will give her the best chance of winning. How would she quantify "best lineup"? It could be measured by comparing points scored vs. points allowed while each possible lineup is on the court. This simple measurement is one way to quantify "best lineup." Of course, the coach will likely also be interested in *why* the "best lineup" is performing as well as it is. In this case, she would need additional measurements to paint a clearer picture of what is happening among those particular teammates. Perhaps that lineup plays better defense, or passes the ball more frequently, or gets more rebounds, or ...

Our class will not focus much on the "meta" question of how a particular qualitative phenomenon is measured with data, but the importance of measurement (and a solid understanding of what the data set is and is not capturing) should always be in the back of a data scientist's mind.


Here are the topics we'll discuss today:

* Statistical programming languages
* Visualization tools (usually included with the above)
* Big Data management software
* Data collection tools

## 2. Statistical Programming Languages
The three main mathematical and statistical programming languages we will use and discuss in this class are R, Python, and Julia. There are many other languages that can be used for statistical analysis: Stata, SAS, SPSS, Matlab, and even JavaScript. Many of the languages listed in the prior sentence were built on C, C++, or Fortran. The latter three are known as **compiled** languages, while all other are known as **scripted** languages. Compiled languages require the user to write code that the CPU can understand, whereas scripted languages allow the user to write code that is more human-readable, at the expense of performance. 

Julia is the newest language and attempts to be a scripted language that can run at compiled speeds. R, Python, and others also have facilities that allow a user to insert C, C++, or Fortran code into the script and achieve greater performance. Such instances are often referred to as "glue code" as they require interfacing between different languages in the same code script.

Below is a table summarizing the main differences between R, Python, and Julia:


|                                    | R         | Python   | Julia    |
|------------------------------------|-----------|----------|----------|
| Date established                   | 1995      | 1991     | 2012     |
| Approximate user base              | large     | largest  | smallest |
| Used for data science              | Yes | Yes  | Yes |
| Used for general-purpose computing | No | Yes  | Yes |
| Open source                        | Yes | Yes  | Yes |
| Web scraping package?              | `rvest`   | `BeautifulSoup` | `Gumbo.jl`, `Cascadia.jl` |
| Visualization library?             | `ggplot2` | `matplotlib` | `Plots.jl`|
| Machine learning library?          | [sporadic](https://cran.r-project.org/web/views/MachineLearning.html) | scikit-learn | `Flux.jl`|
| Biggest advantage                  | `tidyverse` | ubiquity | speed    |
| Biggest disadvantage               | speed     | speed    | age      |

Which programming language should you learn? It depends on what you already know and what you want to do after graduation. If you are already well acquainted with R's tidyverse, I would recommend using this course to learn Python or Julia. If you don't have a good handle on R, I would recommend using this course to learn the R tidyverse, as it is a very popular set of DS tools.

## 3. Web Scraping
With the proliferation of the internet, data is being collected all the time and stored in publicly accessible places (we call these webpages). Thus, one of the tools in a data scientist's toolbox should be the ability to leverage this information to better inform the objective at hand (prediction, "insights", "policy" or what have you). 

### 3.1 How does web scraping work?
Typically *web scraping* involves one of two tasks:

1. Using an application program interface (API) to download data
2. Downloading HTML files and parsing their text to extract data

#### APIs
APIs are employed by many of the most notable web companies (twitter, Facebook, LinkedIn, yelp, etc.). These companies employ APIs so that they can guard their data---either for privacy concerns, or for monetary reasons. So, for example, although Donald Trump's tweets are public record, twitter limits the number of tweets that you can extract from his timeline (3,200 is the current limit). Why do they impose this limit? I'm not sure. 

As another example, LinkedIn limits the information that one can scrape from its website by forcing users to go to through its API (which has precious little information relative to what is in a full LinkedIn profile).

#### Parsing
With all of this talk about gated APIs, you might be thinking, "Why can't I just download the HTML code from the website and parse the data myself?" This can be a useful option in many cases, and it is the only option for websites that don't have an API. One drawback to this approach is that some websites (like LinkedIn or yelp) monitor the IP addresses of all website viewers. If you ping their website too frequently within a given period of time, they may block your access to their website.

### 3.2 Web scraping in the three data science languages
Web scraping can be done in almost any programming language out there. However, there are convenient resources in R, Python, and Julia, which have packages built to parse HTML blocks and automatically load the data into a tabular environment for immediate analysis. We'll talk more about this process in a few weeks. 

## 4. Handling large data sets
In some cases, you might encounter data sets that are too big to fit on a single hard drive (or are too big to fit in R/Julia/Python's memory). For example, consider data held by Amazon on screen clicks, cart inventory, and purchases of all of its 310 million active users. Most desktop computers these days don't come with more than 64GB of RAM, and most laptops don't come with more than 32GB. If you try to load into R a data set that is larger than your machine's RAM capacity, your machine will freeze and you'll have to unplug it if you want to use it again. [This has happened to me a few times in the past with Matlab, so I speak from experience.]

What do you do when you can't open all of your data? Depending on how the data is stored, you may be able to split the files up into manageable chunks (e.g. split the huge file into 100 pieces, where each piece can fit into R). But that's not a viable longterm solution if your data set gets updated, or if you want to compute summary statistics on the full set of data, or if you want to do other operations on it, like create a new variable.

### 4.1 RDDs
The solution to this problem is Resilient Distributed Datasets (RDDs). To use RDDs you need a cluster of computers and software such as Hadoop or Spark. Spark chops your huge data set into manageable chunks and executes actions on those chunks in parallel. One can do many common data operations like subsetting the data, creating summary statistics, etc. The crucial aspect of RDDs is that they are built to withstand any disruption in the computing cluster. So if one of the machines on the cluster happens to fail, the data it was holding can be seamlessly transferred to another machine.

### 4.2 SQL
While not necessarily required for handling mega data sets, SQL is the most common database language to transform data into a more usable form for statistical software to use. With SQL, one can easily subset, merge, and perform other common data transformations.

You will get experience using both SQL and Spark a bit later in the class.
 
## 5. Visualization
Visualization is an important tool for data scientists. Visualization allows humans to see in multiple dimensions what the data looks like, spot outliers, and otherwise perform "sanity checks" on the data. I'll review here the primary visualization tools in the three DS programming languages.

### 5.1 `ggplot2` (R)
`ggplot2` is the visualization package included in the R `tidyverse`. This package has a large user following and the graphic style is immediately recognizable. I personally don't care for the design aesthetic, but it can be hard to argue with ubiquity. If you're interested in learning this, I recommend checking out the [data visualization](http://r4ds.had.co.nz/data-visualisation.html) and [graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html) chapters in the [R for data science](http://r4ds.had.co.nz/) online textbook.

### 5.2 `matplotlib` (Python)
`matplotlib` is the original graphics package for Python. It was designed to mimic Matlab's visualization syntax. Beyond `matplotlib`, there is a `ggplot` package which ports to `ggplot2`, as well as a variety of others.

### 5.3 `Plots.jl` (Julia)
`Plots.jl` is a package that came about in the past year. Its innovation is that, once the user provides it with code, it can output graphics using any other package as a backend. For example, a user can write some code to create a data visualization which creates a graphic using `ggplot2`. Then, by only tweaking one option in that code, the user could output the same graphic in `matplotlib`. This package is a nice way to only have to code once but be able to create graphics in many different styles.

### 5.4 Tableau
Tableau is a software company that produces interactive data visualization products. Tableau primarily bills itself as an interactive product, but there are workarounds to interact with JavaScript and R (see [here](https://stackoverflow.com/questions/18754853/scripts-or-plug-ins-for-tableau)). We won't be covering Tableau in this course, but it is a commonly used visualization tool in the real world, so you should at least know what it is.

## 6. Modeling
Now that you've collected your data, cleaned it up, and visualized it, you're ready to start doing some statistical modeling. The main objectives of statistical modeling are as follows:

1. Use the data to test theories. For example, Amazon may wonder "Are women more likely than men to subscribe to Prime?" Without data this is simply a "hunch" or a belief. 
2. Use the data to predict behavior. For example, many companies need to optimize their inventory management so that the right amount of inventory is in the right stores at the right time. 
3. use the data to explain behavior. This is a bit more difficult, because it goes beyond prediction. Once a company or government knows the "why" behind consumer/citizen behavior, it can optimize its behavior in response. (Note here that the "why" implies a causal relationship---this requires having a particular type of data or requires making additional assumptions and making use of additional statistical methods than are used for prediction.)

## References
* [Common data science file formats](https://www.analyticsvidhya.com/blog/2017/03/read-commonly-used-formats-using-python/)
* [Measurement YouTube video](https://www.youtube.com/watch?v=4RZiWZXdbTw)
