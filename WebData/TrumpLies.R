# Load packages
library(rvest)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)

# Read web page
webpage <- read_html("https://www.nytimes.com/interactive/2017/06/23/opinion/trumps-lies.html")

# Extract records info
results <- webpage %>% html_nodes(".short-desc")

# Building the dataset
records <- vector("list", length = length(results))

for (i in seq_along(results)) {
    date <- str_c(results[i] %>% 
                      html_nodes("strong") %>% 
                      html_text(trim = TRUE), ', 2017')
    lie <- str_sub(xml_contents(results[i])[2] %>% html_text(trim = TRUE), 2, -2)
    explanation <- str_sub(results[i] %>% 
                               html_nodes(".short-truth") %>% 
                               html_text(trim = TRUE), 2, -2)
    url <- results[i] %>% html_nodes("a") %>% html_attr("href")
    records[[i]] <- data_frame(date = date, lie = lie, explanation = explanation, url = url)
}

df <- bind_rows(records)

# Transform to datetime format
df$date <- mdy(df$date)

# Export to csv
write_csv(df, "trump_lies.csv")
