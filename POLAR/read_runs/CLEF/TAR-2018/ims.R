library(tidyverse)

print("read CLEF 2018 IMS runs")

path_runs <- "~/Documents/GitHub/tar/2018-TAR/participant-runs/"

path_participant <- "IMS"

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
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "ims_unipd_t500.task2") ~ "unipd_t500",
      str_detect(path_run, "ims_unipd_t1000.task2") ~ "unipd_t1000",
      str_detect(path_run, "ims_unipd_t1500.task2") ~ "unipd_t1500"
    )) %>%
    mutate(participant = "UNIPD") %>%
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
  filter(feedback != "NS") %>%
  count()
