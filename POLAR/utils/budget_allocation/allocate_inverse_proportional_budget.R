library(dplyr)

allocate_inverse_proportional_budget <- function(topics_tbl, total_budget) {
  # topics_tbl: tibble with columns 'topic' and 'documents'
  # total_budget: total number of documents that can be judged
  
  stopifnot("topic" %in% names(topics_tbl), "documents" %in% names(topics_tbl))
  stopifnot(is.numeric(total_budget) & total_budget > nrow(topics_tbl))
  
  # Compute inverse document weights
  allocation_tbl <- topics_tbl %>%
    mutate(
      inv_weight = 1 / documents,
      inv_weight_norm = inv_weight / sum(inv_weight),
      allocated = pmin(documents, floor(inv_weight_norm * total_budget))
    )
  
  # Correct initial allocation
  # allocation_tbl <- allocation_tbl %>%
  #   mutate(
  #     allocated = pmin(allocated, documents)
  #   )
  
  # Remaining budget after initial allocation
  remaining_budget <- total_budget - sum(allocation_tbl$allocated)
  
  # Distribute remaining budget carefully
  while (remaining_budget > 0) {
    
    # prioritize smaller topics in the redistribution
    allocation_tbl <- allocation_tbl %>%
      arrange(documents)
    
    for (i in seq_len(nrow(allocation_tbl))) {
      
      if (remaining_budget <= 0) break
      
      current_alloc <- allocation_tbl$allocated[i]
      available <- allocation_tbl$documents[i] - current_alloc
      
      if (available > 0) {
        allocation_tbl$allocated[i] <- current_alloc + 1
        remaining_budget <- remaining_budget - 1
      }
    }
    
  }
  
  allocation_tbl <- allocation_tbl %>% select(topic, documents, allocated)
  
  return(allocation_tbl)
}
