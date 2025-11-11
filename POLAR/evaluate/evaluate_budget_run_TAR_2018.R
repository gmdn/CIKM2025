source("utils/evaluate_run.R")
source("utils/get_topic_qrels.R")

source("read_collection/CLEF/TAR-2018/read_qrels_CLEF_2018.R")
source("read_collection/CLEF/TAR-2018/read_topics_CLEF_2018.R")

source("utils/budget_allocation/allocate_even_budget.R")
source("utils/budget_allocation/allocate_proportional_budget.R")
source("utils/budget_allocation/allocate_inverse_proportional_budget.R")
source("utils/budget_allocation/allocate_threshold_capped_greedy.R")


# read runs
source("read_runs/CLEF/TAR-2018/auth.R")

runs_all_participants <- runs

source("read_runs/CLEF/TAR-2018/cnrs.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2018/ecnu.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2018/ims.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)


source("read_runs/CLEF/TAR-2018/sheffield.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2018/uic.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2018/waterloo.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

remove(runs)

runs_all_participants %>%
  group_by(name_overview) %>%
  count() 

# get runs names
runs_names <- unique(runs_all_participants$name_overview)

# filter qrels only test
qrels_test <- qrels %>%
  filter(topic %in% pull(filter(topics, set == "test"), var = topic))

# build topics documents tibble for budget allocation
topics_docs <- qrels_test %>%
  group_by(topic) %>%
  count(name = "documents") %>%
  ungroup()

#### define budget
### 10% of the total number of documents
my_budget <- floor(sum(topics_docs$documents) * 0.1)

#my_budget <- 30000

source("utils/budget_allocation/allocate_even_budget.R")
# allocate even budget
topics_budget <- allocate_even_budget(topics_docs, my_budget)

# remove runs that were not in the overview
# runs_names <- runs_names[str_detect(runs_names, "NO_OVERVIEW", negate = T)]

# evaluate first run
run_to_eval <- runs_all_participants %>% 
  filter(name_overview == runs_names[1])

run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)

results_even_budget <- run_evaluation$summary %>%
  mutate(run = runs_names[1], .before = 0)

# iterate over all the runs starting from the second
for (rn in runs_names[2:length(runs_names)]) {
  
  print(rn)
  
  run_to_eval <- runs_all_participants %>% 
    filter(name_overview == rn)
  
  run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)
  
  run_summary <- run_evaluation$summary %>%
    mutate(run = rn, .before = 0)
  
  results_even_budget <- results_even_budget %>%
    bind_rows(run_summary)
  
}


summary_results_even_budget <- results_even_budget %>%
  group_by(run) %>%
  summarise(across(.cols = c(num_documents, num_shown, num_rel_total, num_rel_retrieved), .fns = sum), 
            across(.cols = c(cost, recall, recall_at_k, auc, ap, wss_at_r95, wss_at_r100, rfbu, ug_at_budget), .fns = mean)) %>%
  rename(map = ap)
summary_results_even_budget


#############P####
source("utils/budget_allocation/allocate_proportional_budget.R")

# allocate proportional budget
topics_budget <- allocate_proportional_budget(topics_docs, my_budget)

# remove runs that were not in the overview
# runs_names <- runs_names[str_detect(runs_names, "NO_OVERVIEW", negate = T)]

# evaluate first run
run_to_eval <- runs_all_participants %>% 
  filter(name_overview == runs_names[1])

run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)

results_proportional_budget <- run_evaluation$summary %>%
  mutate(run = runs_names[1], .before = 0)

# iterate over all the runs starting from the second
for (rn in runs_names[2:length(runs_names)]) {
  
  print(rn)
  
  run_to_eval <- runs_all_participants %>% 
    filter(name_overview == rn)
  
  run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)
  
  run_summary <- run_evaluation$summary %>%
    mutate(run = rn, .before = 0)
  
  results_proportional_budget <- results_proportional_budget %>%
    bind_rows(run_summary)
  
}


summary_results_proportional_budget <- results_proportional_budget %>%
  group_by(run) %>%
  summarise(across(.cols = c(num_documents, num_shown, num_rel_total, num_rel_retrieved), .fns = sum), 
            across(.cols = c(cost, recall, recall_at_k, auc, ap, wss_at_r95, wss_at_r100, rfbu, ug_at_budget), .fns = mean)) %>%
  rename(map = ap)

source("utils/budget_allocation/allocate_inverse_proportional_budget.R")
# allocate inverse proportional budget
topics_budget <- allocate_inverse_proportional_budget(topics_docs, my_budget)

# remove runs that were not in the overview
# runs_names <- runs_names[str_detect(runs_names, "NO_OVERVIEW", negate = T)]

# evaluate first run
run_to_eval <- runs_all_participants %>% 
  filter(name_overview == runs_names[1])

run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)

results_inverse_proportional_budget <- run_evaluation$summary %>%
  mutate(run = runs_names[1], .before = 0)

# iterate over all the runs starting from the second
for (rn in runs_names[2:length(runs_names)]) {
  
  print(rn)
  
  run_to_eval <- runs_all_participants %>% 
    filter(name_overview == rn)
  
  run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)
  
  run_summary <- run_evaluation$summary %>%
    mutate(run = rn, .before = 0)
  
  results_inverse_proportional_budget <- results_inverse_proportional_budget %>%
    bind_rows(run_summary)
  
}


summary_results_inverse_proportional_budget <- results_inverse_proportional_budget %>%
  group_by(run) %>%
  summarise(across(.cols = c(num_documents, num_shown, num_rel_total, num_rel_retrieved), .fns = sum), 
            across(.cols = c(cost, recall, recall_at_k, auc, ap, wss_at_r95, wss_at_r100, rfbu, ug_at_budget), .fns = mean)) %>%
  rename(map = ap)




source("utils/budget_allocation/allocate_threshold_capped_greedy.R")
# allocate inverse proportional budget
topics_budget <- allocate_threshold_capped_greedy(topics_docs, my_budget, tau = 0.1, min_per_topic = 100)

#sum(topics_budget$allocated)

# remove runs that were not in the overview
# runs_names <- runs_names[str_detect(runs_names, "NO_OVERVIEW", negate = T)]

source("utils/evaluate_run.R")

# evaluate first run
run_to_eval <- runs_all_participants %>% 
  filter(name_overview == runs_names[1])

run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)

results_capped_proportional_budget <- run_evaluation$summary %>%
  mutate(run = runs_names[1], .before = 0)

# iterate over all the runs starting from the second
for (rn in runs_names[2:length(runs_names)]) {
  
  print(rn)
  
  run_to_eval <- runs_all_participants %>% 
    filter(name_overview == rn)
  
  run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)
  
  run_summary <- run_evaluation$summary %>%
    mutate(run = rn, .before = 0)
  
  results_capped_proportional_budget <- results_capped_proportional_budget %>%
    bind_rows(run_summary)
  
}


summary_results_capped_proportional_budget <- results_capped_proportional_budget %>%
  group_by(run) %>%
  summarise(across(.cols = c(num_documents, num_shown, num_rel_total, num_rel_retrieved), .fns = sum), 
            across(.cols = c(cost, recall, recall_at_k, auc, ap, wss_at_r95, wss_at_r100, rfbu, ug_at_budget), .fns = mean)) %>%
  rename(map = ap)



remove(rn)
remove(runs_names)
remove(run_to_eval)
remove(run_evaluation)
remove(run_summary)
