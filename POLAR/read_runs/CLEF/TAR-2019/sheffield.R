library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2019-TAR/participant-runs/"

path_participant <- "Runs/University of Sheffield"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "baseline", full.names = T, recursive = T)) {
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name", "empty"), 
                    col_types = "cccnncc") %>%
    select(-empty) %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = "sheffield-baseline") %>%
    mutate(participant = "Sheffield") %>%
    mutate(year = "2019")
  
  runs <- runs %>%
    bind_rows(run)
  
}


remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)

# runs %>%
#   group_by(name_overview) %>%
#   count()
