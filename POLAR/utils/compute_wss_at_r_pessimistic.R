compute_wss_at_r_pessimistic <- function(ranking, r, P_total, N_total) {

  stopifnot(all(ranking %in% c(0, 1)))
  stopifnot(r > 0 && r <= 1)
  
  P_found <- sum(ranking)
  N_found <- length(ranking) - P_found
  
  P_missing <- P_total - P_found
  N_missing <- N_total - N_found
  
  # Extend ranking: first missing negatives, then missing positives
  ranking_full <- c(ranking, rep(0, N_missing), rep(1, P_missing))
  
  # Compute cumulative TPs and FPs
  cum_tp <- cumsum(ranking_full == 1)
  cum_fp <- cumsum(ranking_full == 0)
  
  recall_target <- r * P_total
  
  index <- which(cum_tp >= recall_target)[1]
  
  if (is.na(index)) {
    warning("Even in pessimistic case, target recall not reachable.")
    return(NA_real_)
  }
  
  fp_r <- cum_fp[index]
  
  wss <- (N_total - fp_r) / N_total - (1 - r)
  
  return(wss)

}