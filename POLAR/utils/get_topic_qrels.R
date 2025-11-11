# topic: string
# qrels, dataset from read_all.R
get_topic_qrels <- function(topic, qrels) {
  
  topic_qrels <- qrels %>%
    filter(topic == !!topic) %>%
    #rename(document = pid) %>%
    mutate(relevance = as.integer(relevance)) %>% # transform to integer
    mutate(relevance = ifelse(relevance > 0, 1, 0)) # transform to binary relevance
  
  return(topic_qrels)
  
}