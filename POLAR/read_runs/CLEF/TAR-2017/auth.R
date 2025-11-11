library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "AUTH/simple-eval"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "run", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      name == "run-1" ~ "auth.simple.run1",
      name == "run-2" ~ "auth.simple.run2",
      name == "run-3" ~ "auth.simple.run3",
      name == "run-4" ~ "auth.simple.run4"
    )) %>%
    mutate(participant = "AUTH") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}

path_participant <- "AUTH/cost-effective"

path_runs_dir <- paste0(path_runs, path_participant)

for (path_run in list.files(path_runs_dir, pattern = "run", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      name == "run-5" ~ "auth.simple.run5_NO_OVERVIEW",
      name == "run-6" ~ "auth.simple.run6_NO_OVERVIEW",
      name == "run-7" ~ "auth.simple.run7_NO_OVERVIEW",
      name == "run-8" ~ "auth.simple.run8_NO_OVERVIEW"
    )) %>%
    mutate(participant = "AUTH") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}


remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)

runs %>%
  group_by(name_overview) %>%
  count()
