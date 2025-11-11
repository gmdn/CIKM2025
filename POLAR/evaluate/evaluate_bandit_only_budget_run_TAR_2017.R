source("utils/evaluate_run.R")
source("utils/get_topic_qrels.R")

source("read_collection/CLEF/TAR-2017/read_qrels_CLEF_2017.R")
source("read_collection/CLEF/TAR-2017/read_topics_CLEF_2017.R")

source("utils/budget_allocation/allocate_even_budget.R")
source("utils/budget_allocation/allocate_proportional_budget.R")
source("utils/budget_allocation/allocate_inverse_proportional_budget.R")
source("utils/budget_allocation/allocate_threshold_capped_greedy.R")
source("utils/budget_allocation/allocate_epsilon_greedy_bandit_ug.R")
source("utils/epsilon_greedy_ug.R")

print("read runs")

# read run
source("read_runs/CLEF/TAR-2017/amc.R")

runs_all_participants <- runs

source("read_runs/CLEF/TAR-2017/auth.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/cnrs.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/ecnu.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)


source("read_runs/CLEF/TAR-2017/eth.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)


source("read_runs/CLEF/TAR-2017/iiit.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/ncsu.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/ntu.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/padua.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)


source("read_runs/CLEF/TAR-2017/qut.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/sheffield.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/ucl.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/uos.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

source("read_runs/CLEF/TAR-2017/waterloo.R")

runs_all_participants <- runs_all_participants %>%
  bind_rows(runs)

runs_all_participants %>%
  group_by(name_overview) %>%
  count() 

# get run names
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
my_budget

#my_budget <- 30000 #fixed instead of proportional to total docs

#################
#################
## The process for multi-armed bandit is different from the other approaches.
## It must be computed for every run since it depend on the outcome of the TAR system.
#################
source("utils/budget_allocation/allocate_epsilon_greedy_bandit_ug.R")

# allocate budget and evaluate first run
run_to_eval <- runs_all_participants %>% 
  filter(name_overview == runs_names[1])

# epsilon = 0.1, cost = gain = 1
topics_budget <- allocate_epsilon_greedy_bandit_ug(topics_docs, 
                                                   run_to_eval, 
                                                   qrels_test, 
                                                   my_budget)

run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)

results_epsilon_greedy_budget <- run_evaluation$summary %>%
  mutate(run = runs_names[1], .before = 0)

# iterate over all the runs starting from the second
for (rn in runs_names[21:length(runs_names)]) {
  
  print(rn)
  
  run_to_eval <- runs_all_participants %>% 
    filter(name_overview == rn)
  
  # epsilon = 0.1, cost = gain = 1
  topics_budget <- allocate_epsilon_greedy_bandit_ug(topics_docs, 
                                                     run_to_eval, 
                                                     qrels_test, 
                                                     my_budget)
  
  run_evaluation <- evaluate_run(run_to_eval, qrels_test, topics_budget)
  
  run_summary <- run_evaluation$summary %>%
    mutate(run = rn, .before = 0)
  
  results_epsilon_greedy_budget <- results_epsilon_greedy_budget %>%
    bind_rows(run_summary)
  
}

summary_results_epsilon_greedy_budget <- results_epsilon_greedy_budget %>%
  group_by(run) %>%
  summarise(across(.cols = c(num_documents, num_shown, num_rel_total, num_rel_retrieved), .fns = sum), 
            across(.cols = c(cost, recall, recall_at_k, auc, ap, wss_at_r95, wss_at_r100, rfbu, ug_at_budget), .fns = mean)) %>%
  rename(map = ap)
summary_results_epsilon_greedy_budget


#################
#################
#################

remove(rn)
remove(runs_names)
remove(run_to_eval)
remove(run_evaluation)
remove(run_summary)
rm(summary_results_even_budget)