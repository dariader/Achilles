# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 26.04.2020




df <- as.data.frame(read.table(file="/media/daria_der/linuxdata/neisseria_phylogeny/nii_di_ab_clades/core_genome_ab_clades.csv", sep ="\t", stringsAsFactors = F))
df_2 <- as.data.frame(t(df))

names(df_2) <- unlist(df_2[1,])
rownames(df_2) <- df_2$Name
df_2$Name <- NULL

#### PCA
library(dummies)
df=as.matrix(dummy.data.frame(data = df_2))
### pca
library(FactoMineR)
library(factoextra)
res.famd <- FAMD(df_2, graph = FALSE)
fviz_screeplot(res.famd)
fviz_contrib(res.famd, "var", axes = 2)
quali.var <- get_famd_var(res.famd, "quali.var")
quali.var

fviz_famd_var(res.famd, "quali.var", col.var = "contrib",
              gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)

res.pca <- prcomp(df)
fviz_eig(res.pca)
groups <- df_2$penicillin
fviz_pca_var(res.pca)
fviz_pca_biplot(res.pca)

df <- read.table(file="/media/daria_der/linuxdata/neisseria_invasivity/invasivity_df.csv", sep ="\t")
df <- data.frame(t(df))
names(df) <- df[1,]
head(df)
write.table(df, file="/media/daria_der/linuxdata/neisseria_invasivity/invasivity_df_t.csv", col.names=F, row.names=F, sep="\t")



df <- read.table(file="/media/daria_der/linuxdata/neisseria_resistance/abres_virulence_sg_table", sep = "\t")
names(df) <- c("SG","vir","abres")
df$abres_pot <- as.factor(ifelse(df$abres != 0, 1,0))
df$vir <- as.factor(df$vir)
library(psych)
phi(table(df$abres_pot,df$vir))
library(lattice)
heatmap(as.matrix(df[,2:3]))
