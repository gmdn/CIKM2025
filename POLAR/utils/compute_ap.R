compute_ap <- function(V, P_total) {
  
  stopifnot(all(V %in% c(0, 1)))
  
  if (P_total == 0) {
    warning("No positive instances in ground truth. AP is undefined.")
    return(NA_real_)
  }
  
  cum_tp <- cumsum(V == 1)
  precision <- cum_tp / seq_along(V)
  
  # Mask only the positions where V == 1
  ap <- sum(precision[V == 1]) / P_total
  
  return(ap)
}
