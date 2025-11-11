library(tidyverse)

path_runs <- "~/Documents/GitHub/tar/2017-TAR/participant-runs/"

path_participant <- "Padua/simple"

path_runs_dir <- paste0(path_runs, path_participant)

runs <- tibble(topic = character(), 
               feedback = character(), 
               document = character(),
               rank = numeric(),
               score = numeric(),
               name = character(),
               name_overview = character(),
               year = character())

for (path_run in list.files(path_runs_dir, pattern = "ims", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  #print(unique(run$name))
  
  run <- run %>%
    mutate(name_overview = case_when(
      name == "ims_iafa_m10k150f0m10" ~ "padua.iafa_m10k150f0m10",
      name == "ims_iafap_m10p2f0t150m10" ~ "padua.iafap_m10p2f0m10",
      name == "ims_iafap_m10p5f0m10" ~ "padua.iafap_m10p5f0m10",
      name == "ims_iafas_m10k50f0m10" ~ "padua.iafas_m10k50f0m10"
    )) %>%
    mutate(participant = "Padua") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}

path_participant <- "Padua/cost"

path_runs_dir <- paste0(path_runs, path_participant)

for (path_run in list.files(path_runs_dir, pattern = "ims", full.names = T)) {
  
  #print(f)
  
  run <- read_table(path_run, 
                    col_names = c("topic", "feedback", "document", "rank", "score", "name"), 
                    col_types = "cccnnc") %>%
    mutate(rank = as.integer(rank))
  
  run <- run %>%
    mutate(name_overview = case_when(
      name == "ims_iafapc_m10p5f0t0p2m10" ~ "padua.iafapc_m10p5f0t0p2m10.NO_OVERVIEW",
      name == "ims_iafapc_m10p10f0t150p2m10" ~ "padua.iafapc_m10p10f0t150p2m10.NO_OVERVIEW",
      name == "ims_iafapc_m10p20f0t150p2m10" ~ "padua.iafapc_m10p20f0t150p2m10.NO_OVERVIEW",
      name == "ims_iafapc_m10p20f0t300p2m10" ~ "padua.iafapc_m10p20f0t300p2m10.NO_OVERVIEW"
    )) %>%
    mutate(participant = "Padua") %>%
    mutate(year = "2017")
  
  runs <- runs %>%
    bind_rows(run)
  
}


remove(run)
remove(path_runs)
remove(path_runs_dir)
remove(path_participant)
remove(path_run)
# 
# runs %>%
#   group_by(name_overview) %>%
#   filter(feedback != "NS") %>%
#   count()
