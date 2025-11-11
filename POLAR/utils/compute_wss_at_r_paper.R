compute_wss_at_r_paper <- function(V, r, P_total, N_total) {
  
  # V: vector of 0s (non-relevant) and 1s (relevant), ranked by classifier (most relevant first)
  # r: desired recall level (e.g. 0.75)
  # P_total: total number of relevant documents in the full collection
  # N_total: total number of non-relevant documents in the full collection
  
  stopifnot(all(V %in% c(0, 1)))
  stopifnot(r > 0 && r <= 1)
  
  # Determine how many TPs we need to reach target recall
  recall_target <- r * P_total
  
  # Cumulative true positives and false positives
  cum_tp <- cumsum(V == 1)
  cum_fp <- cumsum(V == 0)
  
  # First index where recall is reached
  index <- which(cum_tp >= recall_target)[1]
  
  if (is.na(index)) {
    warning("Recall target not reached in V. Assuming pessimistic continuation.")
    
    P_found <- sum(V)
    N_found <- length(V) - P_found
    
    P_missing <- P_total - P_found
    N_missing <- N_total - N_found
    
    # Extend pessimistically: negatives before positives
    V_extended <- c(V, rep(0, N_missing), rep(1, P_missing))
    
    cum_tp <- cumsum(V_extended == 1)
    cum_fp <- cumsum(V_extended == 0)
    
    index <- which(cum_tp >= recall_target)[1]
  }
  
  # Compute TP, FP at that cutoff
  TP_r <- cum_tp[index]
  FP_r <- cum_fp[index]
  
  # FN: relevant documents not seen yet
  FN_r <- P_total - TP_r
  
  # TN: non-relevant documents not seen yet
  TN_r <- N_total - FP_r
  
  # Full collection size
  total_docs <- P_total + N_total
  
  # print(paste("Total = ", total_docs))
  # print("at r")
  # print(paste("TP = ", TP_r))
  # print(paste("FP = ", FP_r))
  # print(paste("TN = ", TN_r))
  # print(paste("FN = ", FN_r))
  
  
  # WSS as defined in the TAR literature
  WSS_r <- (TN_r + FN_r) / total_docs - (1 - r)
  
  return(WSS_r)
}


# V <- c(1, 0, 1, 0, 0, 1, 0, 0)  # Top-ranked predictions
# P_total <- 20                  # Total positives in full collection
# N_total <- 80                  # Total negatives
# r <- 0.75                      # Desired recall level
# 
# compute_wss_at_r_paper(V, r, P_total, N_total)
