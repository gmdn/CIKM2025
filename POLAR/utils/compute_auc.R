library(ggplot2)

compute_auc <- function(ranking, P_total, N_total) {
  
  P_found <- sum(ranking)
  N_found <- length(ranking) - P_found
  
  P_missing <- P_total - P_found
  N_missing <- N_total - N_found
  
  # Worst-case: missing negatives come before missing positives
  ranking_full <- c(ranking, rep(0, N_missing), rep(1, P_missing))
  
  # Build ROC points
  cum_tp <- cumsum(ranking_full == 1)
  cum_fp <- cumsum(ranking_full == 0)
  
  tpr <- cum_tp / P_total
  fpr <- cum_fp / N_total
  
  roc_df <- data.frame(
    fpr = c(0, fpr),
    tpr = c(0, tpr)
  )
  
  # Trapezoidal AUC
  auc <- sum(diff(roc_df$fpr) * (head(roc_df$tpr, -1) + tail(roc_df$tpr, -1)) / 2)
  
  # Buil Plot
  ggp <- ggplot(roc_df, aes(x = fpr, y = tpr)) +
    geom_line(color = "firebrick", linewidth = 0.5) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "grey50", linewidth = 0.2) +
    labs(
      title = sprintf(" ROC Curve (AUC = %.3f)", auc),
      x = "False Positive Rate (FPR)",
      y = "True Positive Rate (TPR)"
    ) +
    theme_minimal(base_size = 10)
  
  return(list(auc_score = auc, auc_plot = ggp))
  
}