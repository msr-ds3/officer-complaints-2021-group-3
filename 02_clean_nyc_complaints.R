# Anthony Vallejo & Vanessa Johnson 
# 6/22/2021
# DS3 Week 4 Project 

library(tidyverse)
library(ggplot2)
library(scales)
library(httr)
library(readr)

nyc_office_data <- read_csv("CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv")

df1 <- nyc_office_data %>% group_by(ComplaintID,OfficerID) %>% summarize(Complaints = n()) 

df2 <- df1 %>% group_by(OfficerID) %>% summarize(Complaints_number = n()) %>% arrange(Complaints_number) %>% 
  mutate(complain_sum = cumsum(Complaints_number)/sum(Complaints_number)) %>% 
  summarize(cum_sum = quantile(complain_sum, probs = seq(0,1, 0.1)))

percent_of_complaints <- data.frame(diff(as.matrix(df2))) %>% mutate(rank = row_number()) 

ggplot(percent_of_complaints, aes(x = rank, y = cum_sum, fill = cum_sum)) +
  geom_bar(stat = "identity") + scale_x_continuous(breaks = scales::pretty_breaks(n = 10), name = "Ranks in Deciles" ) +
  scale_y_continuous(name = 'Percent of Complaints', labels = percent) + ggtitle("Distribution of Civilian Misconduct Complaints") +
  theme(axis.text.x =  element_text(angle = 90))

#################################

df3 <- nyc_office_data %>% group_by(FADOType) %>% summarize(QTY = n()) %>% arrange(QTY) 
#%>% ggplot(aes(x = FADOType, y = QTY, fill = FADOType)) + geom_bar(stat = "identity")

df4 <- nyc_office_data %>% 
  mutate(year = as.numeric(format(parse_date(IncidentDate, format = "%m/%d/%Y"),"%Y"))) %>% 
  group_by(year, FADOType) %>% summarize(Occurances = n()) %>% arrange(year) %>% filter(year >= 2006) 

ggplot(df4, aes(x = year, y = Occurances, color = FADOType)) + geom_line() +
  scale_x_continuous(breaks = seq(2006, 2021, by = 1)) + theme(axis.text.x =  element_text(angle = 90)) +
  geom_point()

 
                                  
                    





