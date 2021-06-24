library(tidyverse)
library(ggplot2)
library(scales)

#question: How did the FADOType change over the years

#reading in complaints_data
complaints_data <- read_csv("CCRB%20Complaint%20Database%20Raw%2004.20.2021.csv")

#making a new column for the year
complaints_data <- complaints_data %>% 
  mutate(year = as.numeric(format(parse_date(complaints_data$IncidentDate,format = "%m/%d/%Y"),"%Y")))

#group by year and type of allegation and filter by year and type
complaints_FADOType <- complaints_data %>% group_by(year, FADOType) %>% summarize(times = n()) %>% 
 arrange(year) %>% filter(year >=2006) %>% filter(FADOType != "Untruthful Statement")


#plotting
complaints_FADOType %>% ggplot(aes(x = year, y = times,color = FADOType)) + 
  geom_line() + theme(axis.text.x = element_text(angle = 90)) + 
  scale_x_continuous(breaks = seq(2006,2021,by = 1)) + geom_point()
