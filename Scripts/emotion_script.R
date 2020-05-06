## Source: https://datascienceplus.com/parsing-text-for-emotion-terms-analysis-visualization-using-r/

rm(list=ls())
load('full_data.Rda')

# install.packages("RColorBrewer")
# install.packages("tidyverse")
# install.packages("tidytext")
# install.packages("gplots")
#install.packages('textdata')

require(tidyverse)
require(tidytext)
require(RColorBrewer)
require(gplots)
theme_set(theme_bw(12))

calculate_emotion <- function(matches, name){
  ### pull emotion words and aggregate by year and emotion terms
  emotions <- matches %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words, by = "word") %>%
    filter(!grepl('[0-9]', word)) %>%
    left_join(get_sentiments("nrc"), by = "word") %>%
    filter(!(sentiment == "negative" | sentiment == "positive")) %>%
    group_by(date, sentiment) %>%
    summarize( freq = n()) %>%
    mutate(percent=round(freq/sum(freq)*100)) %>%
    select(-freq) %>%
    ungroup()

  # ## daily line chart
  p <- ggplot(emotions, aes(x=date, y=percent, color=sentiment, group=sentiment)) +
    geom_line(size=1) +
    geom_point(size=0.5) +
    xlab("Year") +
    ylab("Emotion words count (%)") +
    ggtitle(name)
  fname = paste0(name, 'over_time.png')
  ggsave(fname, plot = p)

  # ### calculate overall averages and standard deviations for each emotion term
  overall_mean_sd <- emotions %>%
    group_by(sentiment) %>%
    summarize(overall_mean=mean(percent), sd=sd(percent))
  ### draw a bar graph with error bars
  p <- ggplot(overall_mean_sd, aes(x = reorder(sentiment, -overall_mean), y=overall_mean)) +
    geom_bar(stat="identity", fill="darkgreen", alpha=0.7) +
    geom_errorbar(aes(ymin=overall_mean-sd, ymax=overall_mean+sd), width=0.2,position=position_dodge(.9)) +
    xlab("Emotion Terms") +
    ylab("Emotion words count (%)") +
    ggtitle(name) +
    theme(axis.text.x=element_text(angle=45, hjust=1)) +
    coord_flip( )
  fname = paste0(name, 'overall.png')
  ggsave(fname, plot = p)
  
}

names <- c('US', 'UK', 'NZ', 'CA', 'AU')

for(i in names){
  data <- matches[matches$country == i,]
  calculate_emotion(data, i)
}

save.image('emotion_workspace.RData')
