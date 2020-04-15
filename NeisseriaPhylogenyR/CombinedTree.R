library(ggplot2)
library(lattice)
library(factoextra)

#### data
data = as.data.frame(read.csv(file = "/media/daria_der/linuxdata/Report/Staphylococcus/saureus/cluster_analysis_on_binary_data/edited_st22_clusters_calc.csv", header = T, sep = "\t", quote = "\"",stringsAsFactors = F))
data$BBAPS <- NULL
data$BAPS <- NULL

length(data$Names_on_tree[which(data$BAPS_corrected == 2)])
write.csv(data$Names_on_tree[which(data$BAPS_corrected == 2)], file="/media/daria_der/Seagate_daria_der1/NIIDI/Staphylococcus/saureus/ksnp3_out/kSNP3_out_structured/list_of_loci/list_of_baps_strains_group2", sep="\t", quote=F, row.names=F)
length(data$Names_on_tree)

i = NULL
for(i in colnames(data[,3:ncol(data)])){
  print(i)
  data[,i] <- ifelse(data[,i] == 0, 0, 1)
}

data$BAPS_corrected <- ifelse(data$BAPS_corrected == 2,"EMRSA15 сlade",ifelse(data$BAPS_corrected == 1, "Gaza clade 1","Gaza clade 2" ))

df = as.matrix(data[,3:ncol(data)])

### pca

res.pca <- prcomp(df)
fviz_eig(res.pca)
groups <- data$BAPS_corrected
fviz_pca_ind(res.pca,col.ind = as.factor(groups),geom = c("point"),repel=F,habillage=as.factor(groups),
             addEllipses=TRUE, ellipse.level=0.70)

fviz_pca_biplot(res.pca,col.ind = as.factor(groups),geom = c("point"),repel=F)
fviz_pca_ind(res.pca, habillage=as.factor(groups),
             addEllipses=TRUE, ellipse.level=0.70, )

##### 3D pca
library("pca3d")
pc <- prcomp(df)
gr <- groups
pca3d(pc,group=gr)








################################################################################

# Load dependencies
library("ggplot2")
library("ggdendro")
library("reshape2")
library("grid")
library('dendextend')

rownames(df) <- data$Names_on_tree
otter.dendro <- as.dendrogram(hclust(d = dist(x = df),method = "average"))
#plot(otter.dendro)
otter.order <- order.dendrogram(otter.dendro)
gpar(lwd = 5)

###

hc <- hclust(dist(df), "ave")
dhc <- as.dendrogram(hc)
# Rectangular lines
ddata <- dendro_data(dhc, type = "triangle")
p <- ggplot(segment(ddata)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend))
p

###
fviz_dend(hc, cex = 0.5)
fviz_dend(hc, k = 7,                 # Cut in four groups
          cex = 0.5,                 # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800","#E7B800", "#E7B801", "#FC4E07","#ff00d4"),
          color_labels_by_k = TRUE,  # color labels by groups
          ggtheme = theme_gray()     # Change theme
          )


dendro.plot <- fviz_dend(hc, k = 15,                 # Cut in four groups
          cex = 0.5,
          k_colors = c("#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022","#c20022", "#007626","#0083c2"), # label size
          color_labels_by_k = TRUE,  # color labels by groups
          ggtheme = theme_minimal()     # Change theme
          )



p
####
dendro.plot <- ggdendrogram(data = otter.dendro, rotate = F,labels = F,segments = T)
#print(dendro.plot)
dendro.plot <- dendro.plot + theme(axis.text.y = element_blank(),axis.text.x = element_blank())+scale_size_manual(values=10)
##

otter.long <- melt(data, id = c("Names_on_tree", "BAPS_corrected"))
otter.long$Names_on_tree <- factor(x = otter.long$Names_on_tree,
                                   levels = as.factor(data$Names_on_tree[otter.order]),
                                   ordered = TRUE)


data_for_heatmap <- c("group_3683","group_6740","tsst.1","ebp")
data_f_h <- otter.long[which(otter.long$variable %in% data_for_heatmap),]
heatmap.plot <- ggplot(data = data_f_h, aes(x = variable, y = Names_on_tree)) +
  geom_tile(aes(fill = as.factor(value))) + scale_fill_manual(values=c("white", "gray"))+
  theme(axis.text.y = element_text(size = 10),legend.position = "down",axis.title.y = element_blank(),axis.title.x = element_blank(),axis.text.x = element_blank(),axis.ticks.y = element_blank()) + coord_flip()
heatmap.plot

Baps.cluster.heatmap <- ggplot(data = otter.long, aes(x = Names_on_tree, y= "BAPS clusters")) +
  geom_tile(aes(fill = as.factor(BAPS_corrected))) +
  theme(axis.text.y = element_text(size = 10),axis.text.x = element_blank(),
        legend.position = "down",axis.title.y = element_blank(),axis.title.x = element_blank(),axis.ticks.y = element_blank())
#Baps.cluster.heatmap

#print(heatmap.plot)
grid.newpage()
print(dendro.plot, vp = viewport(x = 0.4825, y = 0.80, width = 0.930, height = 0.5))
#print(Baps.cluster.heatmap, vp = viewport(x = 0.465, y = 0.63, width = 0.885, height = 0.1))
print(heatmap.plot, vp = viewport(x = 0.468, y = 0.45, width = 0.8783, height = 0.4))


#################################### NOT THIS
grid.newpage()
print(dendro.plot, vp = viewport(x = 0.475, y = 0.92, width = 0.921, height = 0.20))
print(Baps.cluster.heatmap, vp = viewport(x = 0.463, y = 0.86, width = 0.865, height = 0.1))
print(heatmap.plot, vp = viewport(x = 0.4265, y = 0.25, width = 0.9385, height = 0.9))


grid.newpage()
print(dendro.plot, vp = viewport(x = 0.468, y = 0.52, width = 1.002, height = 0.90))
print(Baps.cluster.heatmap, vp = viewport(x = 0.463, y = 0.1, width = 0.925, height = 0.2))
############################ compare lists of strains
str_list <- as.data.frame(read.table(file = "/media/daria_der/Seagate_daria_der1/NIIDI/Staphylococcus/saureus/ksnp3_out/kSNP3_out_structured/list_of_loci/compare_lists_df", sep ="\t", header = T, stringsAsFactors = F))
head(str_list)
'%not in%' <- Negate('%in%')

for(i in names(str_list)){
  for(j in 1:1135){
  str_list[j,i] <- as.numeric(ifelse(str_list[j,i] %in% str_list[,"BAPS"] ,1, 0))
  }
}


str_list<- sapply(str_list, as.factor)
for(i in colnames(str_list)){print(i); print(table(str_list[,i]))}










