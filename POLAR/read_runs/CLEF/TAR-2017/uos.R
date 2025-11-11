library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "UOS/test"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "res", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  # check duplicates for this participant
  run <- distinct(run, topic, document, .keep_all = TRUE) %>%
    group_by(topic) %>%
    mutate(rank = row_number()) %>%
    ungroup()
    
  
  run <- run %>%
    mutate(name_overview = case_when(
      str_detect(path_run, "sis.TMAL30Q_BM25.res") ~ "uos.sis.TMAL30Q_BM25",
      str_detect(path_run, "sis.TMBEST_BM25.res") ~ "uos.sis.TMBEST_BM25",
      str_detect(path_run, "sis.bm25_threshold1.res") ~ "uos.bm25_1",
      str_detect(path_run, "sis.bm25_threshold2.5.res") ~ "uos.bm25_2.5",
      str_detect(path_run, "sis.bm25_threshold2.res") ~ "uos.bm25_2",
      str_detect(path_run, "sis.AL30Q_BM25.res") ~ "uos.sis.AL30Q",
      str_detect(path_run, "pubmed.random.res") ~ "uos.sis.pubmed.random_NO_OVERVIEW",
      str_detect(path_run, "sis.bm25_threshold1.5.res") ~ "uos.sis.bm25_1.5_NO_OVERVIEW",
      str_detect(path_run, "sis.BM25.res") ~ "uos.sis.BM25_NO_OVERVIEW",
    )) %>%
    mutate(participant = "AUTH") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}



#remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)

# runs %>%
#   group_by(name_overview) %>%
#   count()
