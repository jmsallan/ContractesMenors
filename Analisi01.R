setwd("~/Documents/ContractesMenors")


library(dplyr)
library(ggplot2)
library(lubridate)

#----llegint dades----

contractes <- readRDS("data/contractes.RDS")
str(contractes)

#----distribució de contractes per import----

contractes %>% ggplot(aes(Import)) + geom_density() + facet_grid(. ~ Any)

contractes %>% filter(Import < 20000) %>% ggplot(aes(Import)) + geom_density() + facet_grid(. ~ Any)

#----nombre de contractes per mes---

contractes %>% group_by(year(Data), month(Data)) %>% summarise(num_contractes=n()) %>% arrange(desc(num_contractes))

contractes %>% group_by(Data) %>% summarise(num_contractes=n()) %>% ggplot(aes(Data, num_contractes)) + geom_line()

contractes %>% group_by(Data) %>% summarise(num_contractes=n()) %>% filter(num_contractes > 1000)
