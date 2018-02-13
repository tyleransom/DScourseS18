library(nbastatR)
library(tibble)
library(dplyr)

# Collect coaching staff info
coaches <- get_coaching_staffs()

filter(coaches, nameCollegeCoach == "Duke")
filter(coaches, nameTeam == "San Antonio Spurs")

thunder_contracts <- get_nba_team_salaries(team_name = "Oklahoma City Thunder", team_slug = NA)
thunder_contracts$value <- thunder_contracts$value/1e6
current_thunder <- filter(thunder_contracts,slugSeason=="2017-18") %>% select(slugSeason,nameTeam, namePlayer, isFinalSeason, value) 
