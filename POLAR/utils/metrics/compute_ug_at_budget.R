compute_ug_at_budget <- function(relevance_vector, gain = 1, cost = 1) {
  # relevance_vector: binary labels ordered by rank
  # cost_penalty: penalty per false positive (non-relevant doc reviewed)
  
  stopifnot(all(relevance_vector %in% c(0, 1)))
  
  # true positives (relevant)
  tp <- sum(relevance_vector == 1)
  
  # false positives (non-relevant)
  fp <- sum(relevance_vector == 0)
  
  # utility gain
  ug <- gain * tp - cost * fp
  
  return(ug)
  
}
