######################################################################################################
# Code to determine word frequency of a text file; adapated from code by Jason Watts, 
# https://www.codementor.io/jhwatts2010/counting-words-with-r-ds35hzgmj
######################################################################################################

# load required libraries
library(readr)
library(tau)
library(tm)
library(plyr)
library(dplyr)
library(ggplot2)
library(plotly)

# 3 long books
book1 <- "KJB"          # king james bible
book2 <- "LesMis"       # les miserables
book3 <- "WarPeace"     # war and peace

# choose book and directory location; can make this refer to GitHub project folder
book <- book1           # book1, book2, or book3
file_loc <- paste0(book, ".txt")

# read text file
data <- tm::PlainTextDocument(readr::read_lines(file = file_loc, progress = interactive()), 
                              heading = book, id = basename(tempfile()), 
                              language = "en", description = "Report File")

# list of stop words to exclude from word count
tm::stopwords("SMART")

# remove stop words - T/F
stop_words <- TRUE

# remove stop words and tokenize text
data <- tau::textcnt(
    if (stop_words == TRUE) {
        tm::removeWords(tm::scan_tokenizer(data), tm::stopwords("SMART"))
    } else {
        tm::scan_tokenizer(data)
    },
    method = "string", n = 1L, lower = 1L
    )

# change list to data frame
data <- plyr::ldply(data, data.frame) 

# set minimum and maximum word frequency to display
a <- 400    #90
b <- 500    #100

# filter using dplyr filter and min/max word frequency
Results <- dplyr::filter(data, data[ , 2] > a & data[ , 2] < b)
colnames(Results) <- c("Word", "Frequency")

# radar plot & save
ggplot2::ggplot(Results, aes(x=Word, y=Frequency, fill=Word)) + 
    geom_bar(width = 0.75,  stat = "identity", colour = "black", size = 1) + coord_polar(theta = "x") + 
    xlab("") + ylab("") + ggtitle(paste0("Word Frequency ", a, "-", b, " in ", book)) + theme(legend.position = "none") + 
    labs(x = NULL, y = NULL)
ggsave(paste0(book, a, "-", b, "_radar.pdf"))

# interactive plotly & save
plotly::ggplotly(ggplot2::ggplot(Results, aes(x=Word, y=Frequency, fill=Word)) + 
                     geom_bar(width = 0.75, stat = "identity", colour = "black", size = 1) + 
                     xlab("") + ylab("") + ggtitle(paste0("Word Frequency ", a, "-", b, " in ", book)) + 
                     theme(legend.position = "none") + labs(x = NULL, y = NULL) + 
                     theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1), 
                           axis.text.x = element_text(angle = 90)) + 
                     theme(panel.background = element_rect(fill = "honeydew1"), 
                           plot.background = element_rect(fill = "antiquewhite"))) %>% 
    config(displaylogo = F) %>% 
    config(showLink = F)
ggsave(paste0(book, a, "-", b, "_plotly.pdf"))
