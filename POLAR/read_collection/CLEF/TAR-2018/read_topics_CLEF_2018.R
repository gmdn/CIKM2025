library(tidyverse)

#**use extract topic data to read topic files**
source("read_collection/CLEF/extract_topic_data.R")

#**CLEF 2018**
path_topics <- "~/Documents/GitHub/tar/2018-TAR/Task2/"

print("read topics")

# ### training
# path_training <- paste0(path_topics, "training/extracted_data")
# 
# # get topic ids from file names
# # topic_ids <- str_remove(string = list.files(path_training, pattern = "pids"), ".pids")
# #**No need if we used topic.title files**
# 
# # build tibble for topic ids and titles
# topics_training <- tibble(topic = character(), title = character())
# 
# # read topic ids and titles
# for (f in list.files(path_training, pattern = "title", full.names = TRUE)) {
#   #print(f)
#   id_title <- str_split(read_lines(f, n_max = -1), pattern = " ", n = 2, simplify = T)
#   topics_training <- topics_training %>% 
#     bind_rows(
#       tibble(topic = id_title[, 1], title = id_title[, 2])
#       )
# }
# 
# topics_training <- topics_training %>%
#   mutate(set = "training")
# topics_training

### test
path_test <- paste0(path_topics, "Testing/topics")

# build tibble for topic ids and titles
topics_test <- tibble(topic = character(), title = character())

# read topic ids and titles
#for (f in list.files(path_test, pattern = "title", full.names = TRUE)) {
for (f in list.files(path_test, full.names = TRUE)) {
  
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

#tail(topics_test)

# topics <- topics_training %>%
#   bind_rows(topics_test) %>%
#   select(set, topic, title)

topics <- topics_test

remove("topics_test")
remove("info")
remove("extract_topic_data")
remove(list = c("f", "path_test", "path_topics"))
