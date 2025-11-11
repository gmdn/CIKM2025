library(tidyverse)

# # read "2017-TAR/all" folder
# pids <- read_delim("~/Documents/GitHub/tar/2017-TAR/all/all.pids", 
#                    delim = " ", 
#                    col_names = c("topic", "pid"),  
#                    col_types = c("cc"))
# #pids
# 
# titles <- read_lines("~/Documents/GitHub/tar/2017-TAR/all/all.title")
# 
# tt <- str_split(titles, " ", n = 2, simplify = T)
# 
# titles <- tibble(topic = tt[, 1], title = tt[, 2])
#   

# print("read qrels")
# qrels <- read_tsv("~/Documents/GitHub/tar/2017-TAR/all/all.qrels",
#                   col_names = c("topic", "Q0", "pid", "relevance"),
#                   col_types = c("cccc"))

# 
# docs_per_topic <- pids %>%
#   group_by(topic) %>%
#   count() %>%
#   arrange(topic)
# 
# docs_per_topic_relevance <- qrels %>%
#   group_by(topic) %>%
#   count() %>%
#   arrange(topic)

corpus <- tibble(topic = character(),
                    pmid = character(),
                    year = character(),
                    title = character(),
                    abstract = character(),
                    mesh = character())

print("read corpus")

for (f in list.files("./data/CLEF-TAR/2017-TAR/tabular/", full.names = T)) {
  
  res <- read_rds(f)
  
  corpus <- corpus %>%
    bind_rows(res)
  
}

remove(res)
remove(f)
