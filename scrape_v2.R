rm(list = ls())
library(rvest)
library(dplyr)
library(rjson)
setwd("~/Documents/NYU/Spring2020/DSGA 1015/Project/TaD_Final_Project")

#Parse JSON of urls of all covid related transcripts
json_data <- fromJSON(file='WebscrapingCode/raw_content.json')

df <- lapply(json_data, function(url) 
{
  data.frame(matrix(unlist(url), ncol = 2, byrow=T))
})

df <- do.call(rbind, df)

colnames(df) <- c('url', 'title')
rownames(df) <- NULL

#Correcting URLs
url_prefix <-'https://www.rev.com/blog/transcripts/'
titles <- gsub(' ', '-', df$title) %>% tolower()
titles <- iconv(titles, 'utf-8', 'ascii', sub='')
titles <- gsub(':', '', titles) 
df$url <- Map(paste, url_prefix, titles, sep = "")

#Selecting only transcripts of Country Leaders
toMatch <- c('Trump', 'Trudeau', 'Morrison', 'Kingdom', 'Britain', 'Zealand', 'Boris', 'Task', 'U.S.', 'Jacinda', 'Ardern')
matches <- df[(grepl(paste(toMatch,collapse='|'), 
                     df$title)), ]
row.names(matches) <- NULL


#Special URLs
matches$url[19] = 'https://www.rev.com/blog/transcripts/donald-trump-coronavirus-press-briefing-transcript-april-16'
matches$url[69] = 'https://www.rev.com/blog/transcripts/transcript-trump-signs-historic-2-trillion-coronavirus-stimulus-bill'
matches$url[93] = 'https://www.rev.com/blog/transcripts/justin-trudeau-coronavirus-update-for-canada-march-20'
matches$url[110] = 'https://www.rev.com/blog/transcripts/donald-trump-mike-pence-and-coronavirus-update-transcript-march-9'


#Function to scrape text without speaker names
scrapetextonly <- function(url, title){
  transcript <- read_html(url)
  text <- transcript %>% 
    rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    xml2::xml_find_all("div/p/text()[preceding-sibling::br]") %>% 
    rvest::html_text()
  
  text_fname = paste(title, '.txt', sep = '')
  text_fname = paste('Data/all_texts/', text_fname, sep = '')
  write_file(text_fname, text)
  return(toString(text))
}

write_file <- function(fname, data){
  fileConn<-file(fname)
  writeLines(data, fileConn)
  close(fileConn)  
}


#try catch for scraping
try_scrape <- function(url, title) {
  out <- tryCatch(
    {
      scrapetextonly(url, title)
    },
    error=function(cond) {
      message(paste("URL does not seem to exist:", url))
      message("Here's the original error message:")
      message(cond)
      return(NA)
    }
  )    
  return(out)
}


#Scraping the text
errs <- c()
for( i in 1:nrow(matches)){
  trans <- try_scrape(toString(matches$url[i]), toString(matches$title[i]))
  if(is.na(trans)){
    errs <- append(errs, i)
  }
  texts <- append(texts, trans)
}

#Adding texts as column to dataframe
matches$text <- texts[2:121]


save.image('scraped.RData')
load('scraped_.RData')
