# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 07.05.2020
library(ggplot2)
library(ggrepel)

df = as.data.frame(read.table(file="/media/daria_der/linuxdata/all_assemblies_NIIDI/contig_correction/bed_files/42_FG.gc_content", sep="\t", quote = "\"", header = T, stringsAsFactors = F))
df = as.data.frame(read.table(file="/media/daria_der/linuxdata/Report/Kerstersia/Annotation/Kerstersia_assembly.gc_content_distribution", sep="\t", quote = "\"", header = T, stringsAsFactors = F))

lower=mean(df$X12_pct_gc) - 3*sd(df$X12_pct_gc)
higher=mean(df$X12_pct_gc) + 3*sd(df$X12_pct_gc)

ggplot(df, aes(x=X4_usercol, y=X12_pct_gc, color = X19_seq_len))+geom_point()+geom_hline(yintercept = mean(df$X12_pct_gc))+geom_hline(yintercept = higher)+geom_hline(yintercept = lower)

#without text
mid<-mean(df$X19_seq_len)
mid<-mean(df$X12_pct_gc)
ggplot(df[,], aes(x=X2_usercol, y=X19_seq_len, color=X12_pct_gc))+geom_smooth()+geom_point()+geom_hline(yintercept = mean(df$X12_pct_gc))+scale_color_gradient2(midpoint=mid, low="green", mid="blue", high="red", space ="Lab")

#with labeled dots
ggplot(df[which(df$X12_pct_gc>1.2*mid|df$X12_pct_gc<0.8*mid),], aes(x=X2_usercol, y=log10(X19_seq_len), color=X12_pct_gc))+geom_smooth()+geom_point()+scale_color_gradient2(midpoint=mid, low="blue", mid="green", high="red", space ="Lab")+geom_text(aes(label=X4_usercol_gene_name))
mid<-mean(scale(df$X12_pct_gc))
mid<-mean(df$X12_pct_gc)
mid<-mean(df$X19_seq_len)
ggplot(df[which(df$X19_seq_len>3000),], aes(x=X2_usercol, color=(X19_seq_len), y=scale(X12_pct_gc)))+geom_smooth()+geom_point()+scale_color_gradient2(midpoint=mid, low="green", mid="blue", high="red", space ="Lab")+geom_text(aes(label=X4_usercol_gene_name))


ggplot(df[which(df$X19_seq_len>3000),], aes(x=X19_seq_len, color=X12_pct_gc, y=scale(X12_pct_gc)))+geom_point()+scale_color_gradient2(midpoint=mid, low="green", mid="blue", high="red", space ="Lab")+geom_label_repel(aes(label=X4_usercol_gene_name))
