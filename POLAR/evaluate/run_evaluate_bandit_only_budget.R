library(xtable)

source("evaluate/evaluate_bandit_only_budget_run_TAR_2017.R")


############# 2017

summary_results_epsilon_greedy_budget %>%
  select(run, recall, recall_at_k, auc, map, wss_at_r95, rfbu, ug_at_budget) %>%
  arrange(desc(recall), run) %>%
  xtable()

years_summary <- summary_results_epsilon_greedy_budget %>%
  mutate(year = "2017", .before = 0) %>%
  mutate(budget = "epsilon", .after = 1)


############# 
############# 2018
############# 

source("evaluate/evaluate_bandit_only_budget_run_TAR_2018.R")


summary_results_epsilon_greedy_budget %>%
  select(run, recall, recall_at_k, auc, map, wss_at_r95, rfbu, ug_at_budget) %>%
  arrange(desc(recall), run) %>%
  xtable()

summary_results_epsilon_greedy_budget <- summary_results_epsilon_greedy_budget %>%
  mutate(year = "2018", .before = 0) %>%
  mutate(budget = "epsilon", .after = 1)


years_summary <- years_summary %>%
  bind_rows(summary_results_epsilon_greedy_budget)




############# 
############# 2019
############# 

source("evaluate/evaluate_budget_run_TAR_2019.R")


summary_results_epsilon_greedy_budget %>%
  select(run, recall, recall_at_k, auc, map, wss_at_r95, rfbu, ug_at_budget) %>%
  arrange(desc(recall), run) %>%
  xtable()

summary_results_epsilon_greedy_budget <- summary_results_epsilon_greedy_budget %>%
  mutate(year = "2019", .before = 0) %>%
  mutate(budget = "epsilon", .after = 1)


years_summary <- years_summary %>%
  bind_rows(summary_results_epsilon_greedy_budget)


###### if you are here....load the years_summary of the previous experiment

# just in case
years_summary_cikm <- years_summary

years_summary_original <- readRDS("../CLEF eHealth 20250429/years_summary.rds")

years_summary <- years_summary %>%
  bind_rows(years_summary_original)


saveRDS(years_summary, "years_summary_cikm.rds")

library(ggplot2)

years_summary_factor <- years_summary

years_summary_factor$budget <- factor(
  years_summary_factor$budget,
  levels = c("even", "proportional", "inverse", "capped", "epsilon")
)



# Boxplot of Recall per Budget Strategy, faceted by Year
ggp <- ggplot(data = years_summary_factor, aes(x = budget, y = recall, fill = budget)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1.5, color = "black") +
  facet_wrap(~ year) +
  labs(
    title = "Recall by Budget Allocation Strategy",
    x = "Budget Allocation Strategy",
    y = "Recall"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")
ggp

ggsave("recall_budget_allocation.pdf", 
       plot = ggp, 
       width = 12, height = 8)




# Boxplot of RFCU per Budget Strategy, faceted by Year
ggp <- ggplot(data = years_summary_factor, aes(x = budget, y = rfbu, fill = budget)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1.5, color = "black") +
  facet_wrap(~ year) +
  labs(
    title = "RFCU by Budget Allocation Strategy",
    x = "Budget Allocation Strategy",
    y = "RFCU"
  ) +
  theme_minimal(base_size = 13) +
  #theme(legend.position = "none")
  theme(
    legend.position = "none",
    strip.text.y = element_text(angle = 0),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
ggp
ggsave("rfcu_budget_allocation.pdf", 
       plot = ggp, 
       width = 12, height = 8)



# Boxplot of UG@B per Budget Strategy, faceted by Year
ggp <- ggplot(data = years_summary_factor, aes(x = budget, y = ug_at_budget, fill = budget)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1.5, color = "black") +
  facet_wrap(~ year) +
  labs(
    title = "UG@B by Budget Allocation Strategy",
    x = "Budget Allocation Strategy",
    y = "UG@B"
  ) +
  theme_minimal(base_size = 13) +
  #theme(legend.position = "none")
  theme(
    legend.position = "none",
    strip.text.y = element_text(angle = 0),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
ggp

ggsave("ug@b_budget_allocation.pdf", 
       plot = ggp, 
       width = 12, height = 8)




install.packages("ggpubr")
library(ggpubr)
library(ggplot2)

ggplot(years_summary_factor, aes(x = recall, y = rfbu)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "steelblue", linewidth = 0.8) +
  stat_cor(method = "pearson", aes(label = paste0("r = ", ..r..)), size = 4) +  # optional: stat_cor from ggcorrplot or ggpubr
  labs(
    title = "Correlation Between Recall and RFBU",
    x = "Recall",
    y = "RFBU"
  ) +
  theme_minimal(base_size = 13)



ggplot(years_summary_factor, aes(x = recall, y = ug_at_budget)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "darkgreen", linewidth = 0.8) +
  stat_cor(method = "pearson", aes(label = paste0("r = ", ..r..)), size = 4) +
  labs(
    title = "Correlation Between Recall and UG@B",
    x = "Recall",
    y = "UG@B"
  ) +
  theme_minimal(base_size = 13)







ggp <- ggplot(years_summary_factor, aes(x = recall, y = rfbu, color = factor(year))) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
  stat_cor(method = "pearson", aes(label = paste0("r = ", ..r..), color = factor(year)), size = 4) +
  labs(
    title = "Correlation Between Recall and RFBU by Year",
    x = "Recall",
    y = "RFBU",
    color = "Year"
  ) +
  theme_minimal(base_size = 13)
ggp
ggsave("rfbu_recall_correlation.pdf", 
       plot = ggp, 
       width = 12, height = 8)



ggp <- ggplot(years_summary_factor, aes(x = recall, y = ug_at_budget, color = factor(year))) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
  stat_cor(method = "pearson", aes(label = paste0("r = ", ..r..), color = factor(year)), size = 4) +
  labs(
    title = "Correlation Between Recall and UG@B by Year",
    x = "Recall",
    y = "UG@B",
    color = "Year"
  ) +
  theme_minimal(base_size = 13)
ggp
ggsave("ug@b_recall_correlation.pdf", 
       plot = ggp, 
       width = 12, height = 8)




my_data <- years_summary_factor

library(dplyr)
library(tidyr)

cor_by_year <- my_data %>%
  group_by(year) %>%
  summarise(
    recall_rfbu = cor(recall, rfbu, use = "complete.obs"),
    recall_ug   = cor(recall, ug_at_budget, use = "complete.obs")
  ) %>%
  pivot_longer(
    cols = c(recall_rfbu, recall_ug),
    names_to = "metric_pair",
    values_to = "correlation"
  )


library(ggplot2)

ggplot(cor_by_year, aes(x = factor(year), y = correlation, fill = metric_pair)) +
  geom_col(position = "dodge", width = 0.6) +
  geom_text(aes(label = round(correlation, 2)), 
            position = position_dodge(width = 0.6),
            vjust = -0.5, size = 4) +
  scale_fill_manual(
    values = c("recall_rfbu" = "#1f77b4", "recall_ug" = "#2ca02c"),
    labels = c("Recall vs RFBU", "Recall vs UG@B")
  ) +
  labs(
    title = "Correlation Between Recall and Other Metrics by Year",
    x = "Year",
    y = "Pearson Correlation",
    fill = "Metric Pair"
  ) +
  theme_minimal(base_size = 13)


library(ggplot2)

ggplot(cor_by_year, aes(x = year, y = correlation, color = metric_pair)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  scale_color_manual(
    values = c("recall_rfbu" = "#1f77b4", "recall_ug" = "#2ca02c"),
    labels = c("Recall vs RFBU", "Recall vs UG@B")
  ) +
  #scale_x_continuous(breaks = unique(cor_by_year$year)) +
  labs(
    title = "Yearly Correlation Trends with Recall",
    x = "Year",
    y = "Pearson Correlation",
    color = "Metric Pair"
  ) +
  theme_minimal(base_size = 13)




library(dplyr)
library(tidyr)

cor_by_year <- my_data %>%
  group_by(year) %>%
  summarise(
    `Recall vs RFBU` = cor(recall, rfbu, use = "complete.obs"),
    `Recall vs UG@B` = cor(recall, ug_at_budget, use = "complete.obs")
  ) %>%
  pivot_longer(
    cols = c(`Recall vs RFBU`, `Recall vs UG@B`),
    names_to = "metric_pair",
    values_to = "correlation"
  )

library(ggplot2)

ggplot(cor_by_year, aes(x = year, y = correlation, color = metric_pair)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  geom_text(aes(label = round(correlation, 2)), 
            vjust = -0.8, size = 4, show.legend = FALSE) +
  scale_color_manual(
    values = c("Recall vs RFBU" = "#1f77b4", "Recall vs UG@B" = "#2ca02c")
  ) +
  scale_x_discrete(breaks = unique(cor_by_year$year)) +
  labs(
    title = "Yearly Correlations with Recall",
    x = "Year",
    y = "Pearson Correlation",
    color = "Metric Pair"
  ) +
  theme_minimal(base_size = 13)
