compute_normalized_ug_at_budget <- function(relevance_vector, num_docs_to_assess, cost_penalty = 1) {
  stopifnot(all(relevance_vector %in% c(0, 1)))
  
  ug <- compute_ug_at_budget(relevance_vector, num_docs_to_assess, cost_penalty)
  
  # Ideal scenario: all relevant docs appear at the top
  ideal_vector <- sort(relevance_vector, decreasing = TRUE)
  ug_max <- compute_ug_at_budget(ideal_vector, num_docs_to_assess, cost_penalty)
  
  if (ug_max == 0) return(NA_real_)  # Avoid divide-by-zero
  
  normalized_ug <- ug / ug_max
  return(normalized_ug)
}
