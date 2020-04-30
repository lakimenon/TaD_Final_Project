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

errs <- c()
for( i in 1:nrow(matches)){
  trans <- try_scrape(toString(matches$url[i]), toString(matches$title[i]))
  if(is.na(trans)){
    errs <- append(errs, i)
  }
  texts <- append(texts, trans)
}
