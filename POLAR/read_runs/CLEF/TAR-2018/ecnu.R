library(tidyverse)

print("read CLEF 2018 ECNU runs")

path_runs <- "~/Documents/GitHub/tar/2018-TAR/participant-runs/"

path_participant <- "ECNU"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "ECNU_TASK2", full.names = T)) {
  
  #print(path_run)
  
  if (!str_detect(path_run, "ECNU_TASK2_RUN3_COMBINE.task2")) {
    
    run <- read_table(path_run, 
                      col_names = c("topic", "feedback", "document", "rank", "score", "name", "empty"), 
                      col_types = "cccnncc") %>%
      select(-empty) %>%
      mutate(rank = as.integer(rank))  
    
  } else {
    
    run <- read_table(path_run,
                      col_names = c("topic", "feedback", "document", "rank", "score", "name"),
                      col_types = "cccnnc") %>%
      mutate(rank = as.integer(rank))
    
  }
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "ECNU_TASK2_RUN1_TFIDF.task2") ~ "ECNU_RUN1",
      str_detect(path_run, "ECNU_TASK2_RUN2_LR.task2") ~ "ECNU_RUN2",
      str_detect(path_run, "ECNU_TASK2_RUN3_COMBINE.task2") ~ "ECNU_RUN3"
    )) %>%
    mutate(participant = "ECNU") %>%
    mutate(year = "2018")
  
  runs <- runs %>%
    bind_rows(run)
  
}


remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)

# runs %>%
#   group_by(name) %>%
#   count()
# 
# tail(runs)
