library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "CNRS"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "trec", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      name == "abrupt" ~ "cnrs.abrupt.all",
      name == "gradual" ~ "cnrs.gradual.all",
      name == "no_AF" ~ "cnrs.noaf.all",
      name == "no_AF_full" ~ "cnrs.noaffull.all"
    )) %>%
    mutate(participant = "CNRS") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}


remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)
