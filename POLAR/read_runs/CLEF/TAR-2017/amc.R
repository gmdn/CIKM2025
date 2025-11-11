library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "AMC/clef-finals/amc.run.res"

path_run <- paste0(path_runs, path_participant)

runs <- read_table(path_run, 
                  col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                  col_types = "cccnnc") %>%
  mutate(rank = as.integer(rank)) %>%
  mutate(name = "amc") %>% #**rename run*
  mutate(name_overview = "amc.run")  %>%
  mutate(participant = "AMC") %>%
  mutate(year = "2017")

remove(path_runs)
remove(path_participant)
remove(path_run)
