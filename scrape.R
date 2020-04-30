rm(list = ls())
library(rvest)
library(dplyr)
library(rjson)


scrapetext <- function(url, filename){
  transcript <- read_html(url)
  
  text <- transcript %>% 
    rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    xml2::xml_find_all("div/p/text()[preceding-sibling::br]") %>% 
    rvest::html_text()

  speakers <- transcript %>% 
    rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    xml2::xml_find_all("div/p/text()[following-sibling::br]") %>% 
    rvest::html_text() %>%
    unique()
  
  speaker_fname = paste(filename, 'speakers.txt', sep = '_')
  text_fname = paste(filename, 'text.txt', sep = '_')
  write_file(speaker_fname, speakers)
  write_file(text_fname, text)
}

write_file <- function(fname, data){
  fileConn<-file(fname)
  writeLines(data, fileConn)
  print('Saved')
  close(fileConn)  
}


d <- data.frame(urls, fnames)
for(i in seq_len(nrow(d))) {
  scrapetext(d[i,1], d[i,2])
}


json_data <- fromJSON(file='WebscrapingCode/raw_content.json')

df <- lapply(json_data, function(url) # Loop through each "play"
{
  data.frame(matrix(unlist(url), ncol = 2, byrow=T))
})

df <- do.call(rbind, df)

colnames(df) <- c('url', 'title')
rownames(df) <- NULL

url_prefix <-'https://www.rev.com/blog/transcripts/'

titles <- gsub(' ', '-', df$title) %>% tolower()
df$url <- Map(paste, url_prefix, titles, sep = "")

toMatch <- c('Trump', 'Trudeau', 'Morrison', 'Kingdom', 'Britain', 'Zealand', 'Boris', 'Task', 'U.S.')
matches <- df[(grepl(paste(toMatch,collapse='|'), 
                        df$title)), ]
row.names(matches) <- NULL
 


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

