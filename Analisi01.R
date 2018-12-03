setwd("~/Documents/ContractesMenors") #canviar per adreça a cada ordinador
setwd("~/Documentos/ContractesMenors") #canviar per adreça a cada ordinador


library(dplyr)
library(ggplot2)
library(lubridate)

#----llegint dades----

contractes <- readRDS("data/contractes.RDS")

#----examen previ---

str(contractes)
unique(contractes$Tipus)

contractes <- contractes %>% mutate(Tipus = sub("Gestió de Serveis Públics", "Gestió de serveis públics", Tipus))

unique(contractes$Organ)
unique(contractes$Adjudicatari)

#contractes amb NAs
contractes %>% filter(is.na(Import))
contractes %>% filter(is.na(Tipus))
contractes %>% filter(is.na(Organ))
contractes %>% filter(is.na(Adjudicatari))
contractes %>% filter(is.na(Objecte))
contractes %>% filter(is.na(Import)) #120 contractes sense import

#contractes als que falta l'import
contractes %>% filter(is.na(Import)) %>% group_by(Tipus, Organ) %>% summarise(NombreContractes=n())
contractes %>% filter(is.na(Import)) %>% group_by(Organ, Adjudicatari) %>% summarise(NombreContractes=n())

#total contractes
contractes %>% summarise(total=sum(Import, na.rm = TRUE), mitjana=mean(Import, na.rm = TRUE))

contractes %>% group_by(Tipus) %>% summarise(total=sum(Import, na.rm = TRUE), mitjana=mean(Import, na.rm = TRUE))

contractes %>% group_by(Organ) %>% summarise(total=sum(Import, na.rm = TRUE), mitjana=mean(Import, na.rm = TRUE))

contractes %>% group_by(Any) %>% summarise(total=sum(Import, na.rm = TRUE), mitjana=mean(Import, na.rm = TRUE))


#----distribució de contractes per import----

contractes %>% ggplot(aes(Import)) + geom_density() + facet_grid(. ~ Any)

contractes %>% filter(Import < 20000) %>% ggplot(aes(Import)) + geom_density() + facet_grid(. ~ Any)

#----nombre de contractes per mes---

contractes %>% group_by(Data) %>% summarise(num_contractes=n()) %>% arrange(desc(num_contractes))
contractes %>% group_by(Data) %>% summarise(total_import=sum(Import)) %>% arrange(desc(total_import))
contractes %>% group_by(Data) %>% summarise(num_contractes=n()) %>% ggplot(aes(Data, num_contractes)) + geom_line()

#----contractacio recurrent----

NoObres <- contractes %>% filter(Tipus !="Obres" & Import >= 17000 & Import <= 17999)
Obres <- contractes %>% filter(Tipus =="Obres" & Import >= 49000 & Import <= 49999)


NoObres %>% group_by(Organ, Adjudicatari) %>% summarise(num_contractes=n(), total=sum(Import)) %>% arrange(desc(num_contractes))

Obres %>% group_by(Organ, Adjudicatari) %>% summarise(num_contractes=n(), total=sum(Import)) %>% arrange(desc(num_contractes))

NoObres %>% filter(Organ=="Departament de Justícia" & Adjudicatari=="MULTIANAU, SL") %>% select(Objecte)

Obres %>% filter(Organ=="Departament de Territori i Sostenibilitat" & Adjudicatari=="FIRTEC SA") %>% select(Objecte)
