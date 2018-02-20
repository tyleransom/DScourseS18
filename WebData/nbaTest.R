library(nbastatR)
library(tibble)
library(dplyr)

# Collect coaching staff info
coaches <- get_coaching_staffs()
print(coaches)

print(filter(coaches, nameCollegeCoach == "Duke"))
print(filter(coaches, nameTeam == "San Antonio Spurs"))

thunder_contracts <- get_nba_team_salaries(team_name = "Oklahoma City Thunder", team_slug = NA)
print(thunder_contracts)
thunder_contracts$value <- thunder_contracts$value/1e6
print(thunder_contracts$value)
current_thunder <- filter(thunder_contracts,slugSeason=="2017-18") %>% select(slugSeason,nameTeam, namePlayer, isFinalSeason, value) 
print(current_thunder)
