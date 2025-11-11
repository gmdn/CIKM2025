library(tidyverse)

#**use extract topic data to read topic files**
source("read_collection/CLEF/extract_topic_data.R")

#**CLEF 2017**
path_topics <- "~/Documents/GitHub/tar/2017-TAR/"

print("read topics")

### training
path_training <- paste0(path_topics, "training/topics_train")

# build tibble for topic ids and titles
topics_training <- tibble(topic = character(), title = character())

# read topic ids and titles
for (f in list.files(path_training, pattern = "[0-9]+", full.names = TRUE)) {
#for (f in list.files(path_training, full.names = TRUE)) {
  
  #print(f)
  
  # extract topic data
  info <- extract_topic_data(f)
  
  topics_training <- topics_training %>% 
    bind_rows(
      tibble(topic = info[1], title = info[2])
    )
}

topics_training <- topics_training %>%
  mutate(set = "training")


### test
path_test <- paste0(path_topics, "testing/topics")

# build tibble for topic ids and titles
topics_test <- tibble(topic = character(), title = character())

# read topic ids and titles
for (f in list.files(path_test, pattern = "[0-9]+", full.names = TRUE)) {
#for (f in list.files(path_test, full.names = TRUE)) {
  
  #print(f)
  
  # extract topic data
  info <- extract_topic_data(f)
  
  topics_test <- topics_test %>% 
    bind_rows(
      tibble(topic = info[1], title = info[2])
    )
}

topics_test <- topics_test %>%
  mutate(set = "test")

topics <- topics_training %>%
  bind_rows(topics_test) %>%
  select(set, topic, title)

remove("topics_training")
remove("topics_test")
remove("info")
remove("extract_topic_data")
remove(list = c("f", "path_test", "path_training", "path_topics"))
