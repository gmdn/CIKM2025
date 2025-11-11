library(dplyr)

allocate_proportional_budget <- function(topics_tbl, total_budget) {
  # topics_tbl: tibble with columns 'topic' and 'documents'
  # total_budget: total number of documents that can be judged
  stopifnot("topic" %in% names(topics_tbl), "documents" %in% names(topics_tbl))
  stopifnot(is.numeric(total_budget) && total_budget > nrow(topics_tbl))
  
  n_topics <- nrow(topics_tbl)
  
  total_documents <- sum(topics_tbl$documents)
  
  # Proportional allocation
  allocation_tbl <- topics_tbl %>%
    mutate(allocated = floor((documents / total_documents) * total_budget))
  
  # Calculate remaining budget due to floor rounding
  remaining_budget <- total_budget - sum(allocation_tbl$allocated)
  
  # Distribute leftover budget
  if (remaining_budget > 0) {
    
    # prioritize smaller topics in the redistribution
    allocation_tbl <- allocation_tbl %>%
      arrange(documents)
    
    for (i in 1:n_topics) {
      
      if (remaining_budget <= 0) break
      
      current_alloc <- allocation_tbl$allocated[i]
      available <- allocation_tbl$documents[i] - current_alloc
      
      if (available > 0) {
        allocation_tbl$allocated[i] <- current_alloc + 1
        remaining_budget <- remaining_budget - 1
      }
    }
    
  }
  
  return(allocation_tbl)
}
