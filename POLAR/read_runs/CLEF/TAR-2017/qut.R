library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "QUT"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "test", full.names = T)) {
  
  #print(path_run)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "coordinateascent_result_bool_ltr_test") ~ "qut.ca_bool_ltr",
      str_detect(path_run, "coordinateascent_result_pico_ltr_test") ~ "qut.ca_pico_ltr",
      str_detect(path_run, "randomforest_result_bool_ltr_test") ~ "qut.rf_bool_ltr",
      str_detect(path_run, "randomforest_result_pico_ltr_test") ~ "qut.rf_pico_ltr",
      str_detect(path_run, "result_bool_es_test") ~ "qut.bool_es",
      str_detect(path_run, "result_pico_es_test") ~ "qut.pico_es",
    )) %>%
    mutate(participant = "QUT") %>%
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
