library(tidyverse)

print("read qrels")

qrels <- read_tsv("~/Documents/GitHub/tar/2017-TAR/all/all.qrels",
                  col_names = c("topic", "Q0", "pid", "relevance"),
                  col_types = c("cccn")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  rename(document = pid)
