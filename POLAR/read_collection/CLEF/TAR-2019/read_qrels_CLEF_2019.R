library(tidyverse)

print("read qrels")

qrels_dta <- read_table("~/Documents/GitHub/tar/2019-TAR/Task2/Testing/DTA/qrels/full.test.dta.abs.2019.qrels",
                        col_names = c("topic", "Q0", "pid", "relevance", "empty"),
                        col_types = c("cccnc")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  select(-"empty") %>%
  mutate(type = "dta")

qrels_intervention <- read_table("~/Documents/GitHub/tar/2019-TAR/Task2/Testing/Intervention/qrels/full.test.intervention.abs.2019.qrels",
                                 col_names = c("topic", "Q0", "pid", "relevance", "empty"),
                                 col_types = c("cccnc")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  select(-"empty") %>%
  mutate(type = "intervention")

qrels_prognosis <- read_table("~/Documents/GitHub/tar/2019-TAR/Task2/Testing/Prognosis/qrels/full.test.prognosis.abs.2019.qrels",
                              col_names = c("topic", "Q0", "pid", "relevance", "empty"),
                              col_types = c("cccnc")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  select(-"empty") %>%
  mutate(type = "prognosis")

qrels_qualitative <- read_table("~/Documents/GitHub/tar/2019-TAR/Task2/Testing/Qualitative/qrels/full.test.qualitative.abs.2019.qrels",
                                col_names = c("topic", "Q0", "pid", "relevance", "empty"),
                                col_types = c("cccnc")) %>%
  mutate(relevance = as.integer(relevance)) %>%
  select(-"empty") %>%
  mutate(type = "qualitative")

qrels <- qrels_dta %>%
  bind_rows(qrels_intervention) %>%
  bind_rows(qrels_prognosis) %>%
  bind_rows(qrels_qualitative) %>%
  rename(document = pid)

remove(qrels_dta)
remove(qrels_intervention)
remove(qrels_prognosis)
remove(qrels_qualitative)
