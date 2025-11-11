source("utils/compute_auc.R")
source("utils/compute_ap.R")
source("utils/compute_wss_at_r_pessimistic.R")
source("utils/metrics/compute_rfbu.R")
source("utils/metrics/compute_ug_at_budget.R")

#source("utils/compute_wss_at_r_paper.R")
#source("utils/compute_wss_at_r_clef.R")

# ranking should be the *ordered* tibble corpus_method (corpus_cosine_sim, for example)
# qrels is the tibble
evaluate_ranking <- function(ranking, qrels, cost_doc = 1, gain_doc = 1) {
  
  # total number of documents
  docs_total <- nrow(qrels)
  
  # total number of relevant documents
  rel_total <- sum(qrels$relevance)
  
  # total number of documents shown
  docs_shown <- nrow(ranking)
  
  # cost: proportion of documents shown compared to total
  cost <- docs_shown / docs_total
  
  # right join, keep all the qrels
  ranking_assessed <- ranking %>%
    inner_join(qrels, by = c("topic", "document")) %>%
    select(topic, document, rank, score, relevance)
  
  # how many relevant articles have been retrieved
  rel_retrieved <- ranking_assessed %>%
    filter(!is.na(score)) %>%
    summarize(sum(relevance)) %>%
    pull()
  
  # how many relevant documeents @ k (rel_total) 
  rel_at_k <- ranking_assessed %>%
    filter(!is.na(score)) %>%
    slice(1:rel_total) %>%
    summarize(sum(relevance)) %>%
    pull()
  
  # Area Under the Curve (score only)
  auc <- compute_auc(ranking_assessed$relevance, rel_total, docs_total - rel_total)[[1]]
  
  # Average Precision
  ap <- compute_ap(ranking_assessed$relevance, rel_total)
  
  # Work Saved over Sampling @ r
  wss_at_r95 <- compute_wss_at_r_pessimistic(ranking_assessed$relevance, 0.95, rel_total, docs_total - rel_total)
  #print(wss_at_r95)
  #wss_at_r95 <- compute_wss_at_r_clef(ranking_assessed$relevance, 0.95, rel_total, docs_total - rel_total)
  # print(wss_at_r95)
  
  wss_at_r100 <- compute_wss_at_r_pessimistic(ranking_assessed$relevance, 1.0, rel_total, docs_total - rel_total)
  #wss_at_r100 <- compute_wss_at_r_clef(ranking_assessed$relevance, 1.0, rel_total, docs_total - rel_total)
  
  ### budget measures
  rfbu <- compute_rfbu(ranking_assessed$relevance, cost_doc)
  
  ug_at_budget <- compute_ug_at_budget(ranking_assessed$relevance, gain_doc, cost_doc)
  
  # store evaluation
  summary <- tibble(topic = qrels$topic[1],
                    num_documents = docs_total,
                    num_shown = docs_shown,
                    cost = cost,
                    num_rel_total = rel_total,
                    num_rel_retrieved = rel_retrieved,
                    recall = rel_retrieved / rel_total,
                    recall_at_k = rel_at_k / rel_total,
                    auc = auc,
                    ap = ap,
                    wss_at_r95 = wss_at_r95,
                    wss_at_r100 = wss_at_r100,
                    rfbu = rfbu,
                    ug_at_budget = ug_at_budget
                    )
  
  return(list(summary = summary, ranking_assessed = ranking_assessed))
  
}

