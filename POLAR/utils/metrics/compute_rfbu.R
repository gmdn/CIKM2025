# Relevant Found per Budget Unit (RFBU)
# RFBU is designed to measure the eﬃciency of relevance detection under a fixed cost-per-review assumption.
compute_rfbu <- function(relevance_vector, cost = 1) {
  # relevance_vector: binary vector of labels (1 = relevant, 0 = non-relevant), ordered by model rank
  # cost_per_doc: cost (time, money, etc.) of assessing a single document
  
  stopifnot(all(relevance_vector %in% c(0, 1)))
  
  total_cost <- length(relevance_vector) * cost
  
  relevant_found <- sum(relevance_vector)
  
  rfbu <- ifelse(test = total_cost == 0, yes = 0, no = relevant_found / total_cost)
  
  return(rfbu)
  
}
