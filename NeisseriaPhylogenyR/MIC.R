# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 09.05.2020
library("ComplexHeatmap")
df=as.data.frame(read.table(file="/media/daria_der/linuxdata/Neisseria_meta/MIC_R", sep="\t", header = T, stringsAsFactors = F))
rownames(df) <- df$Name
df$Name <- NULL
for( i in names(df)){
  df[,i] <- ifelse(df["MIC",i] < df[,i],0, 1)
}
df <- as.matrix(df)
ht = Heatmap(df,col = rev(rainbow(10)))
draw(ht)

