library(tidyverse)

corpus <- tibble(topic = character(),
                    pmid = character(),
                    year = character(),
                    title = character(),
                    abstract = character(),
                    mesh = character())

print("read corpus")

for (f in list.files("./data/CLEF-TAR/2019-TAR/tabular/", full.names = T)) {

  res <- read_rds(f)

  corpus <- corpus %>%
    bind_rows(res)

}

remove(res)
remove(f)
