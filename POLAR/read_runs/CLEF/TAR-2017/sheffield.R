library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "Sheffield"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "Test", full.names = T)) {
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name", "empty"), 
                    col_types = "cccnncc") %>%
    select(-empty) %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "Test_Data_Sheffield-run-1") ~ "sheffield.run1",
      str_detect(path_run, "Test_Data_Sheffield-run-2") ~ "sheffield.run2",
      str_detect(path_run, "Test_Data_Sheffield-run-3") ~ "sheffield.run3",
      str_detect(path_run, "Test_Data_Sheffield-run-4") ~ "sheffield.run4"
    )) %>%
    mutate(participant = "Sheffield") %>%
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
