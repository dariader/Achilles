# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 09.05.2020
library(ggplot2)
df=as.data.frame(read.table(file="/media/daria_der/linuxdata/Klebsiella_phylogeny/kleborate_resistance_r", header=T, quote = "\"", sep="\t")
)
ggplot(df, aes(fill=as.factor(num_resistance_genes), x=Source))+geom_bar(position ="dodge")



