rm(list = ls())
library(rvest)
library(dplyr)
setwd("~/Documents/NYU/Spring2020/DSGA 1015/Project/TaD_Final_Project")

load('scraped.RData')

scrapedate <- function(url){
  transcript <- read_html(url)
  date <- transcript %>% 
    rvest::html_nodes('body') %>% 
    xml2::xml_find_first("//div[contains(@class, 'fl-rich-text')]") %>% 
    rvest::html_text()

  return(date)
}

#try catch for scraping
try_scrape <- function(url) {
  out <- tryCatch(
    {
      scrapedate(url)
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
dates <- c()
for( i in 1:nrow(matches)){
  dt <- try_scrape(toString(matches$url[i]))
  if(is.na(dt)){
    errs <- append(errs, i)
  }
  dates <- append(dates, dt)
}

matches$date <- dates[1:120]

#save.image('scraped_dates.RData')
load('scraped_dates.RData')
