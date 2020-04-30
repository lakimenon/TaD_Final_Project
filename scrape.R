rm(list = ls())
library(rvest)
library(dplyr)

nz_apr6 = 'https://www.rev.com/blog/transcripts/new-zealand-covid-19-briefing-transcript-april-6'
#nz_apr14 = 'https://www.rev.com/blog/transcripts/new-zealand-covid-19-briefing-transcript-april-14'
#nz_apr22 = 'https://www.rev.com/blog/transcripts/new-zealand-covid-19-briefing-transcript-april-22'

#uk_mar16 = 'https://www.rev.com/blog/transcripts/boris-johnson-coronavirus-speech-transcript-uk-pm-tells-uk-to-avoid-non-essential-travel-contact'
#uk_apr1 = 'https://www.rev.com/blog/transcripts/united-kingdom-covid-19-briefing-transcript-april-1'
#uk_apr23 = 'https://www.rev.com/blog/transcripts/united-kingdom-coronavirus-briefing-transcript-april-23'

urls = c(nz_apr6, nz_apr14, nz_apr22, uk_mar16, uk_apr1, uk_apr23)
fnames = c('nz_apr6', 'nz_apr14', 'nz_apr22', 'uk_mar16', 'uk_apr1', 'uk_apr23')

scrapetext <- function(url, filename){
  transcript <- read_html(url)
  
  text <- transcript %>% 
    rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    xml2::xml_find_all("div/p/text()[preceding-sibling::br]") %>% 
    rvest::html_text()

  #speakers <- transcript %>% 
   # rvest::html_nodes(xpath = "//div[contains(@class, 'fl-callout-text')]") %>% 
    #xml2::xml_find_all("div/p/text()[following-sibling::br]") %>% 
    #rvest::html_text() %>%
    #unique()
  
  #speaker_fname = paste(filename, 'speakers.txt', sep = '_')
  text_fname = paste(filename, 'text2.txt', sep = '_')
  #write_file(speaker_fname, speakers)
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

scrapetext(nz_apr6, 'nz_apr_6')
