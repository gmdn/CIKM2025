library(tidyverse)

extract_topic_data <- function(topic_file) {

  #topic_lines <- readLines("~/Documents/GitHub/tar/2018-TAR/Task2/Testing/topics/CD008122")
  topic_lines <- readLines(topic_file, warn = F)

  for (i in 1:length(topic_lines)) {
    
    #print(i)
    
    if (str_starts(string = topic_lines[i], "Topic: ")) {
      
      topic <- topic_lines[i]
      topic <- str_trim(str_split(topic, ": ", simplify = T)[2])
      #print(topic)  
      
    }
    
    if (str_starts(string = topic_lines[i], "Title: ")) {
      
      title <- topic_lines[i]
      title <- str_trim(str_split(title, ": ", simplify = T)[2])
      #print(title)  
      
      break
      
    }
    
  }
  
  return(c(topic, title))
  
}


