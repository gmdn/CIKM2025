library(tidytext)

# corpus must be a two column tibble
# *id
# text
unnest_pipeline <- function(corpus) {
  
  corpus_unnested <- corpus %>%
    unnest_tokens(word, text) %>% 
    anti_join(stop_words, by = "word") %>% ##*** stop words **
    filter(str_detect(word, "^[0-9]+[.|,]?[0-9]*$", negate = T)) ##*** numbers **  
  
  return(corpus_unnested)
  
}

