library(nbastatR)
library(tibble)
library(dplyr)

# Collect coaching staff info
coaches <- coaching_staffs()
print(coaches)

coaches %>% filter(nameCollegeCoach == "Duke") %>% print
coaches %>% filter(nameTeam == "San Antonio Spurs") %>% print

# Player-agent relationships
agents <- players_agents()
agents %>% filter(nameAgent=="Rich Paul") %>% print

# Player salary data
payroll <- hoopshype_salaries()
payroll %<>% mutate(amountContract = amountContract/1e6) # convert to millions of dollars (from dollars)
payroll %>% filter(slugSeason=="2018-19") %>% 
            filter(namePlayer %in% c("Russell Westbrook","Carmelo Anthony","Paul George")) %>% 
            print

payroll %>% filter(namePlayer %in% c("Alex Abrines")) %>% print

payroll %>% filter(namePlayer %in% c("Kawhi Leonard")) %>% 
            select(namePlayer,slugSeason,amountContract,typeOption,isFinalSeason) %>% 
            print
