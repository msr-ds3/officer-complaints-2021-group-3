library(tidyverse)
library(ggplot2)
library(scales)

#question: How did the FADOType change over the years

#reading in complaints_data
complaints_data <- read_csv("CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv")

#making a new column for the year
complaints_data_by_year <- complaints_data %>% 
  mutate(year = as.numeric(format(parse_date(complaints_data$IncidentDate,format = "%m/%d/%Y"),"%Y")))

#group by year and type of allegation and filter by year and type
complaints_FADOType <- complaints_data_by_year %>% group_by(year, FADOType) %>% summarize(times = n()) %>% 
 arrange(year) %>% filter(year >=2006) %>% filter(FADOType != "Untruthful Statement")


#plotting
complaints_FADOType %>% ggplot(aes(x = year, y = times,color = FADOType)) + 
  geom_line() + theme(axis.text.x = element_text(angle = 90)) + 
  scale_x_continuous(breaks = seq(2006,2021,by = 1)) + geom_point()


#percent of abuse of allegations in each decile of officers

abuse_allegations <- complaints_data %>% filter(FADOType == "Force") %>% 
  group_by(OfficerID, ComplaintID) %>% summarize(num_complaints = n()) %>% group_by(OfficerID) %>%
  arrange(num_complaints) %>% summarize(com_per_officer = n()) %>% arrange(com_per_officer) %>%
  mutate(force_complain_sum = cumsum(com_per_officer)/sum(com_per_officer))%>%
  summarize(force_cum_sum = quantile(force_complain_sum, probs = seq(0,1, 0.1)))


percent_of_abuse_complaints <- data.frame(diff(as.matrix(abuse_allegations)))
percent_of_abuse_complaints <- percent_of_abuse_complaints %>% mutate(rank = row_number())



percent_of_abuse_complaints %>% ggplot(aes(x = rank, y = force_cum_sum,fill = force_cum_sum)) + geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(1,10,by = 1)) + scale_y_continuous(name = 'Percent of Abuse Complaints', labels = percent)




