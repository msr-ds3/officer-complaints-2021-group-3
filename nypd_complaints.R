library(tidyverse)
library(ggplot2)
library(scales)

#each bin needs to be 4875.7

complaints_data <- read_csv("CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv")

complaints_data_sorted <- complaints_data %>% group_by(ComplaintID,OfficerID)%>%summarize(num_incidents = n())
df2 <- complaints_data_sorted %>% group_by(OfficerID) %>% summarize(num_complaints = n())

df2 <- df2 %>% arrange(num_complaints) %>%
  mutate(complain_sum = cumsum(num_complaints)/sum(num_complaints))
  
complaints_and_cumsum <- df2 %>%
  summarize(quan_num_complaints = quantile(num_complaints, probs = seq(0,1, 0.1)),quan_cumsum = quantile(complain_sum, probs = seq(0,1, 0.1)) )


percent_of_complaints <- data.frame(diff(as.matrix(complaints_and_cumsum)))
percent_of_complaints <- percent_of_complaints %>% mutate(rank = row_number())


percent_of_complaints %>% ggplot(aes(x = rank, y = quan_cumsum,fill = quan_cumsum)) + geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(1,10,by = 1)) + scale_y_continuous(name = 'Percent of Complaints', labels = percent)

#complaints_outcome <- complaints_data %>% group_by(Allegation) %>% summarize(num_of_type = n()) %>%
  #(num_of_type) %>% mutate(rank = row_number())

#complaints_outcome %>% ggplot(aes(x= rank, y= num_of_type)) + geom_line()


