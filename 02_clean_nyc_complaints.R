# Anthony Vallejo & Vanessa Johnson 
# 6/22/2021
# DS3 Week 4 Project 

library(tidyverse)
library(ggplot2)

nyc_office_data <- read.csv("Documents/officer-complaints-group-3/CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv")

df1 <- nyc_office_data %>% group_by(ComplaintID,OfficerID) %>% summarize(Complaints = n()) 
#%>% arrange(Complaints) %>% mutate(complain_sum = cumsum(Complaints)/sum(Complaints)) %>% 
#summarize(cum_sum = quantile(complain_sum, probs = seq(0,1, 0.1)))
  
df2 <- df1 %>% group_by(OfficerID) %>% summarize(Complaints_number = n()) %>% arrange(Complaints_number) %>% 
  mutate(complain_sum = cumsum(Complaints_number)/sum(Complaints_number)) %>% 
  summarize(cum_sum = quantile(complain_sum, probs = seq(0,1, 0.1)))

percent_of_complaints <- data.frame(diff(as.matrix(df2)))

ggplot(percent_of_complaints, aes(y = cum_sum)) +
  geom_histogram() + stat_bin(bins = 10)

