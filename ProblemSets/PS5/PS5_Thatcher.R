#Question 1
#load package rvest to use for scraping
library(rvest)

#read in the webpage
webpage <- read_html("https://www.nosweatshakespeare.com/resources/shakespeare-insults/")

#get the specific aspects associated with 'h5' - which are the references to which play, act, and line the quote is from
#turn that html to text
ref_html <- html_nodes(webpage, 'h5')
ref <- html_text(ref_html)

#do the same for the quotes
quote_html <- html_nodes(webpage, 'em')
quote <- html_text(quote_html)

#put the quotes and references into a data frame
df <- data.frame(Reference = ref, Quote = quote)

#make that data frame into a csv
write_csv(df, "PS5_Thatcher.csv")

#Question 2
#load the package quantmod
library("quantmod")
getSymbols("CPIAUCNS", src = "FRED")

#plot the last 30 years
plot(CPIAUCNS, subset = '1978-01-01::2018-01-01')