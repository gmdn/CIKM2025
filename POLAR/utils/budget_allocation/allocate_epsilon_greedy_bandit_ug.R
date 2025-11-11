allocate_epsilon_greedy_bandit_ug <- function(topics_docs, run_to_eval, qrels_test, budget, epsilon = 0.1, gain = 1, cost = 1) {
  
  run_participant <- run_to_eval %>%
    inner_join(qrels_test, by = c("topic", "document")) %>%
    #select(topic, document, rank, score, relevance)
    select(topic, relevance)
  
  topics_relevance <- run_participant %>%
    group_by(topic) %>%
    summarise(relevance_vec = list(as.integer(relevance))) %>%
    deframe()
  
  res <- epsilon_greedy_ug(topics_relevance, budget, epsilon, gain, cost)
  
  allocation_tbl <- topics_docs %>%
    #mutate(allocated = res$pulls)
    full_join(tibble(topic = res$topics, allocated = res$pulls), by = "topic") %>%
    mutate(allocated = replace_na(allocated, 0))
  
  return(allocation_tbl)
  
}