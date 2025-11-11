source("utils/evaluate_ranking.R")

evaluate_run <- function(run, qrels, topics_budget = NULL, cost = 1, gain = 1) {
  
  summary_eval <- NULL
  ranking_assessed <- NULL
  
  for (tpc in unique(qrels$topic)) {
    
    #print(tpc)
    
    # get qrels for this topic
    tpc_qrels <- get_topic_qrels(tpc, qrels)
    
    # get ranking for this topic
    ranking <- run %>% filter(topic == tpc)
    
    # limit ranking given budget
    if (!is.null(topics_budget)) {
      
      tpc_budget <- topics_budget %>% 
        filter(topic == tpc) %>%
        pull(allocated)
      
      ranking <- slice(ranking, 1:tpc_budget)
    
      # evaluate ranking
      evaluation <- evaluate_ranking(ranking, tpc_qrels, cost, gain)  
      
    } else {
      
      # evaluate ranking
      evaluation <- evaluate_ranking(ranking, tpc_qrels, cost, gain)
      
    }
    
    
    
    
    # merge evaluation on all topics
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
  
  return(list(summary = summary_eval, ranking_assessed = ranking_assessed))
  
}
