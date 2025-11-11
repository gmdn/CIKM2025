allocate_even_budget <- function(topics_tbl, total_budget) {
  
  # topics_tbl: tibble with columns 'topic' and 'documents'
  # total_budget: total number of documents that can be judged
  stopifnot("topic" %in% names(topics_tbl), "documents" %in% names(topics_tbl))
  stopifnot(is.numeric(total_budget) && total_budget > nrow(topics_tbl))
  
  n_topics <- nrow(topics_tbl)
  base_allocation <- floor(total_budget / n_topics)  # Equal share
  
  # Allocate base budget first
  allocation_tbl <- topics_tbl %>%
    mutate(
      allocated = pmin(documents, base_allocation)
    )
  
  remaining_budget <- total_budget - sum(allocation_tbl$allocated)
  
  #print(remaining_budget)
  
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
  
  return(allocation_tbl)
}

# library(tibble)
# 
# topics_tbl <- tibble(
#   topic = c("Topic_A", "Topic_B", "Topic_C"),
#   documents = c(100, 80, 150)
# )
# 
# total_budget <- 90
# 
# allocate_even_budget(topics_tbl, total_budget)
# 
