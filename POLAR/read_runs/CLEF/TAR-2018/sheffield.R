library(tidyverse)

print("read CLEF 2018 Sheffield runs")

path_runs <- "~/Documents/GitHub/tar/2018-TAR/participant-runs/"

path_participant <- "SHEF"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "task2", full.names = T)) {
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name", "empty"), 
                    col_types = "cccnncc") %>%
    select(-empty) %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "sheffield-feedback.task2") ~ "shef-feed",
      str_detect(path_run, "sheffield-general_terms.task2") ~ "shef-general",
      str_detect(path_run, "sheffield-query_terms.task2") ~ "shef-query"
    )) %>%
    mutate(participant = "Sheffield") %>%
    mutate(year = "2018")
  
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
