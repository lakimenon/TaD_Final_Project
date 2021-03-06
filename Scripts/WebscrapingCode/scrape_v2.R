rm(list = ls())
library(rvest)
library(dplyr)
library(rjson)

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
df$url <- Map(paste, url_prefix, titles, sep = "")

#Selecting only transcripts of Country Leaders
toMatch <- c('Trump', 'Trudeau', 'Morrison', 'Kingdom', 'Britain', 'Zealand', 'Boris', 'Task', 'U.S.')
matches <- df[(grepl(paste(toMatch,collapse='|'), 
                     df$title)), ]
row.names(matches) <- NULL


#Scraping required texts
scrapetextonly <- function(url){
  transcript <- read_html(url)
  text <- transcript %>% 
    rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    xml2::xml_find_all("div/p/text()[preceding-sibling::br]") %>% 
    rvest::html_text()
  return(toString(text))
}

texts <- list()
for(url in matches$url){
  trans <- scrapetextonly(url)
  texts <- append(texts, trans)
}

#Append transcript text to table with URL and title
matches$texts <- texts
