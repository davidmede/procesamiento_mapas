setwd("D:/Sioma/mapas/Altavista_altamar/Cartografia/Lotes_csv")
dir()
altavista<-read.csv("puntos_lotes_altavista.csv")


library(tidyr)

altavista$lot<-"Lote :"

altavista2<-unite(altavista, "Nombre", 
                  lot, Nombre.del.lote, sep=" ")

write.csv(altavista2, "puntos_lotes_altavista2.csv")


#####################################################

altamar<-read.csv("puntos_lotes_altamar.csv")


altamar$lot<-"Lote :"

altamar2<-unite(altamar, "Nombre", 
                  lot, Nombre.del.lote, sep=" ")

write.csv(altamar2, "puntos_lotes_altamar2.csv")
