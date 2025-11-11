# query should be the query_tfidf$tfidf table
# documents  should be the documents_tfidf$tfidf table
# this function will discard any document without any match with the query
compute_cosine_sim <- function(query, documents) {
  
  # compute vector norms
  query_norm <- query %>%
    group_by(docid) %>%
    summarize(tfidf_norm = norm_vec(tfidf))
  
  documents_norm <- documents %>%
    group_by(docid) %>%
    summarize(tfidf_norm = norm_vec(tfidf))
  
  cosine_sim <- documents %>%
    inner_join(query, by = c("word")) %>%
    inner_join(documents_norm, by = c("docid.x" = "docid")) %>%
    inner_join(query_norm, by = c("docid.y" = "docid")) %>%
    group_by(docid.x) %>%
    summarize(cosine_sim = sum(tfidf.x / tfidf_norm.x * tfidf.y / tfidf_norm.y)) %>%
    # mutate(topic = query$docid[1], .before = 0) %>% do not add topic id here
    rename(document = docid.x)
  
  return(cosine_sim)
  
}