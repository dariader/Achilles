# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 01.05.2020
library(dummies)
library("ape")
library(gplots)
library(lattice)
library("factoextra")
library("pheatmap")
library(RColorBrewer)
library(viridis)
library(ggplot2)
library(dplyr)
library(reshape)
## aniA, norB и fHbp typing
df = as.data.frame(read.table(file="/media/daria_der/linuxdata/neisseria_phylogeny/aniA_norB_fhBp/named_resulting_dataframe.csv", sep = "\t", header = T))
rownames(df) <- df$Name
##
data <- melt(df,id.vars = "Name")
head(data)

ggplot(data, aes(x=variable, fill = value))+ geom_bar(position = "dodge") + theme(axis.text.x = element_text(angle = 90, hjust = 1))


####
df = as.data.frame(read.table(file="/media/daria_der/linuxdata/neisseria_phylogeny/aniA_norB_fhBp/named_resulting_dataframe.csv", sep = "\t", header = T))
rownames(df) <- df$Name

data <- as.data.frame(sapply(df,as.factor))
data[sapply(data, is.character)] <- lapply(data[sapply(data, is.character)], as.factor)
mat = as.matrix(data)

##
Heatmap(discrete_mat, name = "mat", col = colors)

library("ComplexHeatmap")
discrete_mat = mat
colors = structure(1:4, names = letters[1:4])
Heatmap(discrete_mat)

discrete_mat = matrix(sample(letters[1:4], 100, replace = TRUE), 10, 10)
colors = structure(1:4, names = letters[1:4])
Heatmap(discrete_mat, name = "mat", col = colors)

library(FactoMineR)
tea = df

rownames(tea) <- tea$Name
tea$Name <- NULL

res.mca <- MCA(tea,
               ncp = 20,            # Number of components kept
               graph=T)

res.hcpc <- HCPC (res.mca, graph = F, max = 30)

# Dendrogram
dendro <-
  fviz_dend(res.hcpc, show_labels = T,  type = "rectangle",repel = TRUE,k_colors = "jco")
dendro
# Individuals facor map
fviz_cluster(res.hcpc, geom = c("text"), main = "Factor map", show_labels = T,repel = T,ellipse.type = "convex")

dist(res.mca)

get_mca_ind(res.mca)

fviz_contrib(res.mca, choice ="var", axes = 1)

fviz_mca_ind(res.mca,
             addEllipses = TRUE, repel = TRUE)
fviz_mca_var(res.mca, repel = TRUE)


res.hcpc$desc.ind
res.hcpc$desc.var$test.chi2

res.hcpc$desc.var$category

