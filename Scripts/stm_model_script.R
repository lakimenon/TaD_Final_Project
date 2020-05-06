library(dplyr)
library(topicmodels)
library(stm)
library(quanteda)

rm(list=ls())
load('Workspaces/scraped_dates.RData')

US_words <- c('Donald', 'Trump', 'U.S.', 'Task', 'Pence') %>% paste(collapse = '|')
UK_words <- c('Britain', 'Kingdom', 'Boris', 'UK') %>% paste(collapse = '|')
AU_words <- c('Australia', 'Morrison') %>% paste(collapse = '|')
NZ_words <- c('Zealand', 'NZ', 'Jacinda', 'Ardern') %>% paste(collapse = '|')
CA_words <- c('Trudeau', 'Canada') %>% paste(collapse = '|')

matches$country <- ifelse(grepl(UK_words, matches$title), 'UK', 
                          ifelse(grepl(AU_words, matches$title), 'AU', 
                          ifelse(grepl(CA_words, matches$title), 'CA', 
                          ifelse(grepl(NZ_words, matches$title), 'NZ', 
                          ifelse(grepl(US_words, matches$title), 'US', 'err')))))
matches$country <- factor(matches$country)
matches$date <- as.Date(matches$date, '%b %d, %Y')
matches$date_numeric <- as.numeric(matches$date)


matches$text <- as.character(matches$text)
matches$text <- iconv(matches$text, 'utf-8', 'ascii', sub='')

remove_custom <- c('canada', 'canadian','canadians', 'zealand', 'zealands', 'maori', 'america', 'american', 'americans',
                      'australia', 'australian', 'australians', 'president', 'will', 'well', 'can')
processed_transcripts<-textProcessor(matches$text,meta=matches, customstopwords = remove_custom)

model_search <- searchK(processed_transcripts$documents, processed_transcripts$vocab, K=c(5, 10, 15, 20), seed = 2020)
plot(model_search)

#10 models performs the best
stm_model <- stm(processed_transcripts$documents, processed_transcripts$vocab, K=10, seed = 2020,  
                 prevalence= ~country + s(date_numeric), content = ~country, data = processed_transcripts$meta)
labelTopics(stm_model)
plot.STM(stm_model, type = 'summary')
topicQuality(stm_model, documents = processed_transcripts$documents)


reg <- estimateEffect(1:10 ~country + s(date_numeric), stm_model, meta = processed_transcripts$meta)

plot(reg, 'date_numeric', stm_model, topics = c(9, 10), 
     method = "continuous", xaxt = "n", xlab = "Date")

plot(reg, "country", model = stm_model,
     method = "difference", cov.value1 = "US", cov.value2 = "NZ")


plot(stm_model, type = "labels")
plot(stm_model, type="perspectives", topics = 10, covarlevels = c('US', 'NZ'))

save.image('model_workspace.RData')
save(matches, file = 'full_data.Rda')
