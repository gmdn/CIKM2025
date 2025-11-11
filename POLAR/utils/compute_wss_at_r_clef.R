compute_wss_at_r_clef <- function(V, r, P_total, N_total) {
  # V: vector of 0s and 1s, ranked by model (1 = relevant, 0 = not relevant)
  # r: desired recall level (e.g., 0.95)
  # P_total: total relevant documents in the collection
  # N_total: total non-relevant documents in the collection
  
  stopifnot(all(V %in% c(0, 1)))
  stopifnot(r > 0 && r <= 1)
  
  recall_target <- r * P_total
  cum_tp <- cumsum(V == 1)
  
  # Check if recall is reached
  if (sum(V) < recall_target) {
    # CLEF fallback: recall not reached → WSS = 0
    return(0)
  }
  
  # Find the rank at which recall r is first achieved
  index <- which(cum_tp >= recall_target)[1]
  
  # Compute WSS@r using full collection size as denominator
  total_docs <- P_total + N_total
  
  wss <- (total_docs - index) / total_docs - (1 - r)
  
  return(wss)
}
# 
# V <- c(1, 0, 0, 1, 0, 0, 1, 0)  # Model's ranked predictions
# P_total <- 20
# N_total <- 80
# r <- 0.95
# 
# compute_wss_at_recall_clef(V, r, P_total, N_total)
