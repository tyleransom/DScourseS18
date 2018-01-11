# Data Science Toolbox
The following is a (slightly) deeper look at the data science workflow, with more details about specific software, programming languages, and other skills often used for data science.

As discussed in the previous reading by [Gentzkow & Shapiro](https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf), everything that can be automated should be automated. That is how companies can make use of data science insights ``at scale'' (to quote the DS vernacular). In fact, automation is the reason we write code in the first place. And it's the source of innovation in data science.

Here are the topics we'll discuss today:

* Statistical programming languages
* Visualization tools (usually included with the above)
* Big Data management software
* Data collection tools

## 1. Statistical Programming Languages
The three main mathematical and statistical programming languages we will use and discuss in this class are R, Python, and Julia. There are many other languages that can be used for statistical analysis: Stata, SAS, SPSS, Matlab, and even JavaScript. Many of the languages listed in the prior sentence were built on C, C++, or Fortran. The latter three are known as **compiled** languages, while all other are known as **scripted** languages. Compiled languages require the user to write code that the CPU can understand, whereas scripted languages allow the user to write code that is more human-readable, at the expense of performance. 

Julia is the newest language and attempts to be a scripted language that can run at compiled speeds. R, Python, and others also have facilities that allow a user to insert C, C++, or Fortran code into the script and achieve greater performance. Such instances are often referred to as ``glue code'' as they require interfacing between different languages in the same code script.

Below is a table summarizing the main differences between R, Python, and Julia:


|                                    | R         | Python   | Julia    |
|------------------------------------|-----------|----------|----------|
| Date established                   | 1995      | 1991     | 2012     |
| Approximate user base              | large     | largest  | smallest |
| Used for data science              | - [x]     | - [x]    | - [x]    |
| Used for general-purpose computing | - [ ]     | - [x]    | - [x]    |
| Open source                        | - [x]     | - [x]    | - [x]    |
| Web scraping package?              | `rvest`   | `BeautifulSoup` | `Gumbo.jl`, `Cascadia.jl` |
| Visualization library?             | `ggplot2` | `PyPlot` | `Plots.jl`|
| Machine learning library?          | [sporadic](https://cran.r-project.org/web/views/MachineLearning.html) | scikit-learn | `Flux.jl`|
| Biggest advantage                  | `tidyverse` | ubiquity | speed    |
| Biggest disadvantage               | speed     | speed    | age      |

Which programming language should you learn? It depends on what you already know and what you want to do after graduation. If you are already well acquainted with R's tidyverse, I would recommend using this course to learn Python or Julia. If you don't have a good handle on R, I would recommend using this course to learn the R tidyverse, as it is a very popular set of DS tools.

## 2. Web Scraping
With the proliferation of the internet, data is being collected all the time and stored in publicly accessible places (we call these webpages). Thus, one of the tools in a data scientist's toolbox should be the ability to leverage this information to better inform the objective at hand (prediction, ``insights'', ``policy'' or what have you). 

### 2.1 How does web scraping work?
Typically *web scraping* involves one of two tasks:

1. Using an application program interface (API) to download data
2. Downloading HTML files and parsing their text to extract data

#### APIs
APIs are employed by many of the most notable web companies (twitter, Facebook, LinkedIn, yelp, etc.). These companies employ APIs so that they can guard their data---either for privacy concerns, or for monetary reasons. So, for example, although Donald Trump's tweets are public record, twitter limits the number of tweets that you can extract from his timeline (3,200 is the current limit). Why do they impose this limit? I'm not sure. 

As another example, LinkedIn limits the information that one can scrape from its website by forcing users to go to through its API (which has precious little information relative to what is in a full LinkedIn profile).

#### Parsing
With all of this talk about gated APIs, you might be thinking, "Why can't I just download the HTML code from the website and parse the data myself?" This can be a useful option in many cases, and it is the only option for websites that don't have an API. One drawback to this approach is that some websites (like LinkedIn or yelp) monitor the IP addresses of all website viewers. If you ping their website too frequently within a given period of time, they may block your access to their website.

### 2.2 Web scraping in the three data science languages
Web scraping can be done in almost any programming language out there. There are convenient resources in R, Python, and Julia, which have packages built to parse HTML blocks and automatically load the data into a tabular environment for immediate analysis. We'll talk more about this process in a few weeks. 

## 3. 

## 4. 

### 4.1

## 5. 

