epsilon_greedy_ug <- function(topics_relevance, budget, epsilon = 0.1, gain = 1, cost = 1) {
  # topics_relevance: list of binary relevance vectors (1 = relevant, 0 = non-relevant)
  # budget: total number of pulls
  # epsilon: exploration rate
  # gain, cost: parameters for UG@B reward
  
  n_topics <- length(topics_relevance)
  n_docs   <- sapply(topics_relevance, length)
  
  # tracking
  rewards <- rep(0, n_topics)
  pulls   <- rep(0, n_topics)
  indices <- rep(1, n_topics) # next doc index for each topic
  
  total_reward <- 0
  history <- data.frame(step = integer(), topic = integer(), reward = numeric())
  
  # generate random arm if two or more arms have the same average reward
  # (avoid getting stuck with one topic in case of sparse rewards)
  argmax_random <- function(x, idx) {
    m <- max(x[idx])
    cand <- idx[which(x[idx] == m)]
    sample(cand, 1)
  }
  
  for (t in 1:budget) {
    
    # filter available topics (those with docs left)
    available <- which(indices <= n_docs)
    if (length(available) == 0) {
      message("No more documents left across topics. Stopping early at step ", t-1)
      break
    }
    
    # Ensure each available topic is tried once before exploitation
    untried <- available[pulls[available] == 0]
    if (length(untried) > 0) {
      topic <- untried[1]
    } else if (runif(1) < epsilon) {
      topic <- sample(available, 1)  # explore among available topics
    } else {
      avg <- ifelse(pulls > 0, rewards / pulls, -Inf) # -Inf avoids selecting empty arms
      #topic <- available[which.max(avg[available])]
      topic <- argmax_random(avg, available)
    }
    
    # pull next doc from topic
    rel <- topics_relevance[[topic]][indices[topic]]
    reward <- ifelse(rel == 1, gain, -cost)  # UG@B-style reward
    
    # update stats
    total_reward <- total_reward + reward
    rewards[topic] <- rewards[topic] + reward
    pulls[topic] <- pulls[topic] + 1
    indices[topic] <- indices[topic] + 1
    
    history <- rbind(history, data.frame(step = t, topic = topic, reward = reward))
    
  }
  
  return(list(total_reward = total_reward,
              topics = names(topics_relevance),
              pulls = pulls,
              rewards = rewards,
              history = history))
}
