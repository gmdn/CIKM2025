library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2019-TAR/participant-runs/"

path_participant <- "Runs/University of Amsterdam/abs"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "uva", full.names = T)) {
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "abs-hh-ratio-ilps@uva") ~ "abs-hh-ratio-ilps",
      str_detect(path_run, "abs-th-ratio-ilps@uva") ~ "abs-th-ratio-ilps"
    )) %>%
    mutate(participant = "ILPS") %>%
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
#   filter(feedback != "NS") %>%
#   count()
