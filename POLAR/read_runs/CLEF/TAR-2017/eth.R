library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "ETH"

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
                    col_names = c("topic", "feedback", "document", "rank", "score", "name", "empty"), 
                    col_types = "cccnncc") %>%
    select(-empty) %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "trec_final_old_m1") ~ "eth.m1",
      str_detect(path_run, "trec_final_old_m2") ~ "eth.m2",
      str_detect(path_run, "trec_final_old_m4") ~ "eth.m4"
    )) %>%
    mutate(participant = "ETH") %>%
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
