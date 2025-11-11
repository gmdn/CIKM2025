library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "IIIT"

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
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "run1") ~ "iiit.run1",
      str_detect(path_run, "run2") ~ "iiit.run2",
      str_detect(path_run, "run3") ~ "iiit.run3",
      str_detect(path_run, "run4") ~ "iiit.run4",
      str_detect(path_run, "run5") ~ "iiit.run5_NO_OVERVIEW",
      str_detect(path_run, "run6") ~ "iiit.run6_NO_OVERVIEW",
      str_detect(path_run, "run7") ~ "iiit.run7_NO_OVERVIEW",
      str_detect(path_run, "run8") ~ "iiit.run8_NO_OVERVIEW"
    )) %>%
    mutate(participant = "IIIT") %>%
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
