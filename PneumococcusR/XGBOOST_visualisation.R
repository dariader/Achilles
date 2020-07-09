# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 01.05.2020

library(ggplot2)
df <- read.table(file="/media/daria_der/linuxdata/Pneumococcus/Data/XGBOOST_annotation/Pen_associated_proteins", sep ="\t", header = T)
ggplot(df, aes(x=Name,y=percent*100))+geom_col()+coord_flip()

meta <- as.data.frame(read.table(file="/home/daria_der/Downloads/temp/id81source", sep="\t",stringsAsFactors = F,header = T))
rownames(meta) <- meta$id
meta$id <- NULL
df <- as.data.frame(read.table(file="/home/daria_der/Downloads/temp/variable1", sep ="\t", stringsAsFactors = F, header = T))
rownames(df) <- df$Locus
df$Locus <- NULL
df_2 <- as.data.frame(t(df))
df_2$id <- rownames(df_2)

df_2 <- merge(meta, df_2, by="id", all.y = T)
head(colnames(df_2))
groups <- df_2$source

df_3 <- df_2[,3:500]
colnames(df_2)
#### PCA
library(dummies)
df=as.matrix(dummy.data.frame(data = df_3))
### pca
library(FactoMineR)
library(factoextra)
res.famd <- FAMD(df_2, graph = FALSE)
fviz_screeplot(res.famd)
fviz_contrib(res.famd, "var", axes = 2)
quali.var <- get_famd_var(res.famd, "quali.var")
quali.var

res.pca <- prcomp(df)
fviz_eig(res.pca)
dimdesc(PCA(df)) ## Корелляция переменных с измерениями(больше-лучше)
## группы по которым будем красить кластеры
#fviz_pca_var(res.pca)
#fviz_pca_biplot(res.pca)
  fviz_pca_ind(res.pca, habillage = df_2$SPNE00321, labels=F)
