# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 25.02.2020
library(ggplot2)
df = as.data.frame(read.table(file = "/home/daria_der/PycharmProjects/Achilles/trimmed_corrected", sep = " ", header = T, stringsAsFactors = T))
df_2 = as.data.frame(read.table(file = "/home/daria_der/PycharmProjects/Achilles/trimmed_corrected", sep = " ", header = T, stringsAsFactors = T))

df = as.data.frame(read.table(file = "/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/full_out",sep=" ", header = T, check.names = F, stringsAsFactors = F))
  colnames(df) <- c("Baps2", "predicate")
  ggplot(data = df, aes(x = as.factor(Baps2), fill = as.factor(predicate)))+geom_histogram(position = "dodge",stat="count")+labs(x = "in second baps cluster (0 = no, 1=yes)")

ggplot(data = df, aes_string(x = "penicillin", y = "X125.aroE"))+geom_point()

library(ggplot2)

colnames(df)
for(i in colnames(df)){
  ggplot(data = data.frame(df[,i]), aes(x=i, fill ="Baps2"))
}

#если пробел перед скобкой - петля не работает

#### PCA
library(dummies)
df=as.matrix(dummy.data.frame(data = df))

### pca

res.pca <- prcomp(df)
fviz_eig(res.pca)
groups <- df_2$penicillin
fviz_pca_var(res.pca)
fviz_pca_ind(res.pca,col.ind = as.factor(groups),geom = c("point"),repel=F,habillage=as.factor(groups),
             addEllipses=TRUE, ellipse.level=0.70)




#### Correlation

levelplot(cor(df))

glm(df)
head(df)

###



df = as.data.frame(read.table(file = "/media/daria_der/linuxdata/all_assemblies_NIIDI/contig_correction/serogroup/serogroup_predictions_1579789648.1179786.tab", sep = "\t", header = T))
df$is_invasive <- as.factor(df$is_invasive)
levels(df$is_invasive)<- c("-","+")
'%not in%' <-  Negate('%in%')

ggplot(data = df[which(df$SG %not in% c("E","L","NG")),], aes(x = SG, fill = ST))+geom_histogram(stat="count", position = "dodge") + labs(x="Серогруппа", y="Число изолятов")
table(df$is_invasive)


#data=as.data.frame(t(read.table(file="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence.Rtab",header = T)))
#colnames(data) <- data[1,]
data=as.data.frame(read.table(file="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence.csv",header = T, sep="\t"))
data <- as.data.frame(unlist(data[2:nrow(data),]))
meta <- read.table(file="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/baps_metadata", sep = "\t", header = T)
##sort meta and data


write.csv(data, file="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/gene_presence_absence.csv",row.names=FALSE)
