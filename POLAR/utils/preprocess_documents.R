source("utils/unnest_pipeline.R")

# corpus must be a two column tibble
# docid
# text
preprocess_documents <- function(corpus) {
  # corpus_unnested must be a two column tibble
  # docid
  # word
  corpus_unnested <- unnest_pipeline(corpus)
  #head(corpus_unnested)
  
  # corpus_unnested_tf must be a three column tibble
  # docid
  # word
  # tf
  corpus_unnested_tf <- corpus_unnested %>%
    count(name = "tf", docid, word)
  #head(corpus_unnested_tf)
  
  # corpus_doc_length
  # docid
  # dl (document length)
  corpus_doc_length <- corpus_unnested_tf %>%
    group_by(docid) %>%
    summarise(dl = sum(tf))
  #head(corpus_doc_length)
  
  corpus_unnested_tf <- corpus_unnested_tf %>%
    inner_join(corpus_doc_length, by = "docid")
  #head(titles_tf_length)
  
  # corpus_unnested_df
  # docid
  # document frequency (of the term)
  corpus_unnested_df <- corpus_unnested_tf %>%
    group_by(word) %>%
    count(name = "df")
  #head(corpus_unnested_df)
  
  # average document length
  average_doc_length <- corpus_unnested_tf %>%
    distinct(docid, dl) %>%
    summarise(avdl = mean(dl)) %>%
    pull()
  
  # corpus_preprocessed
  # docid
  # word
  # tf
  # dl
  # df
  # avdl
  corpus_preprocessed <- corpus_unnested_tf %>% 
    inner_join(corpus_unnested_df, by = "word") %>% 
    add_column(avdl = average_doc_length)
  
  return(corpus_preprocessed)
  
}
