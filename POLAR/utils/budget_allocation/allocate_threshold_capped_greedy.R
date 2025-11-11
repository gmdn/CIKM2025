library(dplyr)

allocate_threshold_capped_greedy <- function(topics_tbl, total_budget, tau = 0.1, min_per_topic = 10) {
  # topics_tbl: tibble with columns 'topic' and 'documents'
  # total_budget: total number of documents that can be judged
  # tau: threshold fraction per topic (default 30%)
  # min_per_topic: minimum number of documents to allocate per topic
  
  stopifnot("topic" %in% names(topics_tbl), "documents" %in% names(topics_tbl))
  stopifnot(is.numeric(total_budget) && total_budget > nrow(topics_tbl))
  stopifnot(is.numeric(tau) && tau > 0 && tau <= 1)
  stopifnot(is.numeric(min_per_topic) && min_per_topic >= 0)
  
  n_topics <- nrow(topics_tbl)
  
  if (min_per_topic * n_topics > total_budget) {
    stop("Not enough total budget to allocate the minimum per topic.")
  }
  
  allocation_tbl <- topics_tbl %>%
    mutate(allocated = min(documents, min_per_topic)) %>%
    arrange(documents)  # Prioritize small topics
  
  remaining_budget <- total_budget - sum(allocation_tbl$allocated)
  
  # Distribute remaining budget carefully
  #while (remaining_budget > 0) {
  
  for (i in 1:n_topics) {
    
    if (remaining_budget <= 0) break
    
    doc_count <- allocation_tbl$documents[i]
    already_allocated <- allocation_tbl$allocated[i]
    
    # Maximum allowed for this topic (thresholded)
    max_alloc <- min(doc_count, floor(tau * doc_count))
    
    # Additional allocatable documents for this topic
    extra_possible <- max(0, max_alloc - already_allocated)
    
    alloc <- min(extra_possible, remaining_budget)
    
    allocation_tbl$allocated[i] <- already_allocated + alloc
    
    remaining_budget <- remaining_budget - alloc
    
    #print(remaining_budget)
    
  }
  
  # Redistribute leftover budget one by one
  while (remaining_budget > 0) {
    
    # prioritize smaller topics in the redistribution
    allocation_tbl <- allocation_tbl %>%
      arrange(documents)
    
    #print(sum(allocation_tbl$allocated))
    
    for (i in 1:n_topics) {
      
      # if there is still room for a topic add 1
      if (allocation_tbl$documents[i] - allocation_tbl$allocated[i] > 0) {
        allocation_tbl$allocated[i] <- allocation_tbl$allocated[i] + 1
        remaining_budget <- remaining_budget - 1
      }
      
      if (remaining_budget <= 0) break
      
    }
    
  }
  
  allocation_tbl <- allocation_tbl %>%
    select(topic, documents, allocated)
  
  return(allocation_tbl)
}
