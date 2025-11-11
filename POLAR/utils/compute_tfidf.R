# see paper TF-IDF uncovered
# need a tibble of a prprocessed corpus (preprocess_corpus.R)
compute_tfidf <- function(corpus_prep, idf = NULL) {
  
  num_docs <- length(unique(corpus_prep$docid))
  
  tfidf <- tibble(docid = corpus_prep$docid,
                  word = corpus_prep$word,
                  tf = corpus_prep$tf / corpus_prep$dl)
  
  if (is.null(idf)) {
    
    idf <- corpus_prep %>%
      distinct(word, df) %>%
      mutate(idf = -log(df / num_docs)) %>%
      select(word, idf) 
  
    tfidf <- tfidf %>% 
      inner_join(idf, by = "word") %>%
      mutate(tfidf = tf * idf)
  
    return(list(tfidf = tfidf, idf = idf))
    
  } else {
    
    tfidf <- tfidf %>% 
      inner_join(idf, by = "word") %>%
      mutate(tfidf = tf * idf)
    
    return(list(tfidf = tfidf))
    
  }
  
  
}