# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 16.04.2020
library(factoextra)
data=read.csv(file="/media/daria_der/linuxdata/neisseria_virulence/core_genome_R_Frame_transp_fin_is_invasive.csv", sep=" ", header = T,stringsAsFactors=FALSE)
names(data)
#data <- data[,1:40]
data$Locus <- NULL
data[is.na(data)] <- 0
data <- as.data.frame(sapply(data,as.factor))
data[sapply(data, is.character)] <- lapply(data[sapply(data, is.character)],
                                       as.factor)
str(data)

df = as.matrix(as.matrix(sapply(data, as.numeric))  )

### pca
res.pca <- prcomp(df)
fviz_eig(res.pca)
groups <- data$is_invasive
fviz_pca_ind(res.pca,col.ind = as.factor(groups),geom = c("point"),repel=F,habillage=as.factor(groups))
install.packages("ppclust")
library("ppclust")
library("dplyr")
library(cluster)
library(fclust)
library(psych)

res.fcm <- fcm(data, centers=3)