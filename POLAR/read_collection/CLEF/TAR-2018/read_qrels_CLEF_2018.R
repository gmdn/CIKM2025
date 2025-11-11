library(tidyverse)

print("read qrels")

qrels <- read_table("~/Documents/GitHub/tar/2018-TAR/Task2/Testing/qrels/full.test.abs.2018.qrels",
                  col_names = c("topic", "Q0", "pid", "relevance"),
                  col_types = c("cccn")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  rename(document = pid)
