setwd("~/Documents/ContractesMenors")

library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)

#----neteja de dades----
#font: http://exteriors.gencat.cat/ca/ambits-dactuacio/contractacio-publica/direccio-general-de-contractacio-publica-/impuls-de-la-transparencia/contractacio-menor-dels-departaments/
#per millorar la legibilitat, s'ha eliminat manualment la fila 8 del fitxer de contractes de 2017

contractes.2015 <- read_xlsx("data/2015.xlsx", skip=5)
contractes.2016 <- read_xlsx("data/Menors-2016.xlsx", skip=6)
contractes.2017 <- read_xlsx("data/Contractes-menors-detallats-2017-web.xlsx", skip=6)


contractes.2015 <- contractes.2015 %>% mutate(Any=2015)
contractes.2016 <- contractes.2016 %>% mutate(Any=2016)
contractes.2017 <- contractes.2017 %>% select(c(1:5 ,7)) %>% mutate(Any=2017)
names(contractes.2017) <- c("Tipus", "Organ", "Adjudicatari", "Objecte", "Import", "Data", "Any")

names(contractes.2015) <- names(contractes.2017)
names(contractes.2016) <- names(contractes.2017)

contractes <- bind_rows(contractes.2015, contractes.2016, contractes.2017)

saveRDS(contractes, "data/contractes.RDS")

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
