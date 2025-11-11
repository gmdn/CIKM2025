source("utils/preprocess_documents.R")
source("utils/compute_tfidf.R")
source("utils/norm_vec.R")
source("utils/compute_cosine_sim.R")
source("utils/get_topic_qrels.R")
source("utils/evaluate_ranking.R")

evaluate_corpus <- function(corpus, topics) {
  
  summary_eval <- NULL
  ranking_assessed <- NULL
  
  for (tpc in topics$topic) {
    
    print(paste0("evaluating topic: ", tpc))
    
    # extract documents 
    documents <- corpus %>%
      filter(topic == tpc) %>%
      select(pmid, title) %>%
      rename(docid = pmid, text = title)
    
    documents_prep <- preprocess_documents(documents)
    
    documents_tfidf <- compute_tfidf(documents_prep)
    
    query <- topics %>% 
      filter(topic == tpc) %>%
      rename(docid = topic, text = title)
    
    query_prep <- preprocess_documents(query)
    
    query_tfidf <- compute_tfidf(query_prep, documents_tfidf$idf)
    
    documents_cosine <- compute_cosine_sim(query_tfidf$tfidf, documents_tfidf$tfidf)
    
    tpc_qrels <- get_topic_qrels(tpc, qrels)
    
    ranking <- documents_cosine %>%
      arrange(desc(cosine_sim), document) %>%
      rename(score = cosine_sim) %>%
      add_column(rank = 1:nrow(documents_cosine), .before = "score") %>%
      add_column(topic = tpc, .before = "document")
    
    evaluation <- evaluate_ranking(ranking, tpc_qrels)
    
    if (is.null(summary_eval)) {
      
      summary_eval <- evaluation$summary
      ranking_assessed <- evaluation$ranking_assessed
      
    } else {
      
      summary_eval <- summary_eval %>%
        bind_rows(evaluation$summary)
      ranking_assessed <- ranking_assessed %>%
        bind_rows(evaluation$ranking_assessed)
      
    }
    
  }
  
  return(list(summary_eval = summary_eval, 
              ranking_assessed = ranking_assessed))
  
}