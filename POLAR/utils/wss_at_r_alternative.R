# Compute WSS@r
wss_at_r <- function(total_documents, total_relevant, docs_screened, recall_target) {
  if (recall_target <= 0 || recall_target > 1) {
    stop("Recall target must be between 0 and 1 (exclusive of 0).")
  }
  if (docs_screened > total_documents) {
    stop("Number of documents screened cannot exceed total number of documents.")
  }
  wss <- 1 - (docs_screened / total_documents) - (1 - recall_target)
  return(wss)
}

# Example usage
# Total documents: 1000
# Relevant documents: 100
# Documents screened to reach 80% recall (i.e. find 80 relevant docs): 300

wss_at_r(total_documents = 1000, total_relevant = 100, docs_screened = 300, recall_target = 0.8)
