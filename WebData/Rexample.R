library(rvest)
library(tidyverse)

h <- read_html("https://en.wikipedia.org/wiki/Current_members_of_the_United_States_House_of_Representatives")

reps <- h %>%
    html_node("#mw-content-text > div > table:nth-child(18)") %>%
    html_table()

    reps <- reps[,c(1:2,4:9)] %>%
        as_tibble()

