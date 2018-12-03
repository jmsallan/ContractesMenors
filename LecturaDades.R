setwd("~/Documents/ContractesMenors")
setwd("~/Documentos/ContractesMenors")

library(readxl)

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

saveRDS(unique(contractes$Organ), "data/organs.RDS")
saveRDS(unique(contractes$Adjudicatari), "data/adjudictaris.RDS")
