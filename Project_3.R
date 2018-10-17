library(tidyRSS)
library(RCurl)
library(rvest)
data_science_skills <-tidyfeed("https://www.google.com/alerts/feeds/00182648300908928214/18036739630504927351", sf = TRUE)

data_science_skills$item_link
data_science_skills$item_content

#################################################TESTING BELOW THIS LINE#######################################################################
data_science_skills_url<-getURL("https://www.google.com/alerts/feeds/00182648300908928214/18036739630504927351")
data_science_skills_url

article<-getURL("https://www.peoplematters.in/article/jobs/over-50000-positions-in-data-science-and-machine-learning-vacant-in-india-19575")
article


####################### schedule R script to run daily and output DF of RSS feed to SQL table? access SQL table for frequent words?
library(sqldf)
library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "ServerName",
                 Database = "DBName",
                 UID = "UserName",
                 PWD = "Password")
dbWriteTable(conn = con, 
             name = "TableName", 
             value = x)  ## x is any data frame

