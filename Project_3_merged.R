library(tidyRSS)
library(RCurl)
library(rvest)

# load required libraries
library(readr)
library(tau)
library(tm)
library(plyr)
library(dplyr)
library(ggplot2)
library(plotly)
data_science_skills <-tidyfeed("https://www.google.com/alerts/feeds/00182648300908928214/18036739630504927351", sf = TRUE)
names(data_science_skills)
data_science_skills$item_link
data_science_skills$item_content
title_vector<-c(t(data_science_skills$item_content))
title_vector

# list of stop words to exclude from word count
tm::stopwords("SMART")

# remove stop words - T/F
stop_words <- TRUE

# remove stop words and tokenize text
data <- tau::textcnt(
  if (stop_words == TRUE) {
    tm::removeWords(tm::scan_tokenizer(title_vector), tm::stopwords("SMART"))
  } else {
    tm::scan_tokenizer(title_vector)
  },
  method = "string", n = 1L, lower = 1L
)
data
# set minimum and maximum word frequency to display
a <- 10 #400    #90
b <- 500    #100

# change list to data frame
data <- plyr::ldply(data, data.frame) 

# filter using dplyr filter and min/max word frequency
Results <- dplyr::filter(data, data[ , 2] > a & data[ , 2] < b)
colnames(Results) <- c("Word", "Frequency")
Results
# radar plot & save
ggplot2::ggplot(Results, aes(x=Word, y=Frequency, fill=Word)) + 
  geom_bar(width = 0.75,  stat = "identity", colour = "black", size = 1) + coord_polar(theta = "x") + 
  xlab("") + ylab("") + ggtitle(paste0("Word Frequency ", a, "-", b, " in ", book)) + theme(legend.position = "none") + 
  labs(x = NULL, y = NULL)
ggsave(paste0("data_science_skills", a, "-", b, "_radar.pdf"))

# interactive plotly & save
plotly::ggplotly(ggplot2::ggplot(Results, aes(x=Word, y=Frequency, fill=Word)) + 
                   geom_bar(width = 0.75, stat = "identity", colour = "black", size = 1) + 
                   xlab("") + ylab("") + ggtitle(paste0("Word Frequency ", a, "-", b, " in ", "data_science_skills")) + 
                   theme(legend.position = "none") + labs(x = NULL, y = NULL) + 
                   theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1), 
                         axis.text.x = element_text(angle = 90)) + 
                   theme(panel.background = element_rect(fill = "honeydew1"), 
                         plot.background = element_rect(fill = "antiquewhite"))) %>% 
  config(displaylogo = F) %>% 
  config(showLink = F)
ggsave(paste0("data_science_skills", a, "-", b, "_plotly.pdf"))