library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "Waterloo/"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "txt", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "A-rank-normal") ~ "waterloo.A-rank-normal",
      str_detect(path_run, "B-rank-normal") ~ "waterloo.B-rank-normal",
      str_detect(path_run, "A-thresh-normal") ~ "waterloo.A-thresh",
      str_detect(path_run, "B-thresh-normal") ~ "waterloo.B-thresh",
      str_detect(path_run, "A-rank-cost") ~ "waterloo.A-rank-cost_NO_OVERVIEW",
      str_detect(path_run, "A-thresh-cost") ~ "waterloo.A-thresh-cost_NO_OVERVIEW",
      str_detect(path_run, "B-rank-cost") ~ "waterloo.B-rank-cost_NO_OVERVIEW",
      str_detect(path_run, "B-thresh-cost") ~ "waterloo.B-thresh-cost_NO_OVERVIEW"
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

# runs %>%
#   #filter(feedback != "NS") %>%
#   group_by(name_overview) %>%
#   count()
