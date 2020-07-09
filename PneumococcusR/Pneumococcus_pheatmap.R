library("pheatmap")
library(RColorBrewer)
library(viridis)

save_pheatmap_png <- function(x, filename, width=1400, height=1000, res = 200) {
  png(filename, width = width, height = height, res = res)
  grid::grid.newpage()
  grid::grid.draw(x$gtable)
  dev.off()
}

df <- as.data.frame(read.csv(file = "/media/daria_der/linuxdata/Pneumococcus/Python_scripts/data/full_data.csv", sep =";", header = T))

pheamapit <- function(gene1, gene2, df){
  require("pheatmap")
  n_strains_in_each_group <- table(df[,gene1])
  dat <- table(df[,c(gene1,gene2)])

 for(i in rownames(dat)){
  dat[i,] <- dat[i,]/n_strains_in_each_group[i] * 100 }
  print(colSums(t(dat)))
  breaksList <-  seq(0, 100, by = 1)
  pheatm<- pheatmap(dat, display_numbers = F, main = paste0(gene1, "~", gene2, ", % of each group"),color = colorRampPalette(c('white','red'))(length(breaksList)),breaks = breaksList, number_color = "black")
  save_pheatmap_png(pheatm, paste0("/media/daria_der/linuxdata/Pneumococcus/Data/XGBOOST_pictures/",gene1,"_",gene2,".png"))
  return(paste0("/media/daria_der/linuxdata/Pneumococcus/Data/XGBOOST_pictures/",gene1,"_",gene2,".png"))
}

ery_list <- c("orf7", "SPN23F12770", "orf21", "SPN23F08280", "SPN23F16900", "SPN23F06360", "SPN23F13090", "carB", "SPN23F21040", "ndk", "SPN23F21420", "SPN23F11990", "SPN23F21040", "SPN23F11990", "SPN23F19110", "SPN23F02310", "PEN", "SPN23F03020")
for(i in ery_list){
  print(pheamapit("ERY",i,df))
}

pen_list <- c("orf7", "orf21", "SPN23F09650", "orf9", "orf18", "orf13", "orf23", "SPN23F12010", "SPN23F03050", "SPN23F12420", "SPN23F13090", "prfA", "SPN23F01280", "tmk", "SPN23F12640", "rpoB", "SPN23F09110", "SPN23F00940", "SPN23F08690")

for(i in pen_list){
  print(pheamapit("PEN",i,df))
}

serogroup_predicted_list <- c("murD", "gnd", "atpG", "agaD", "mraW", "aliA", "gcnA", "bgaA", "aliA", "adhE", "lacD2", "luxS", "clpX", "pabB", "pbpX", "atpB", "carB", "atpD", "blpS", "gcaD", "dexB", "murD", "argS", "dexB", "infB", "aroA", "glnA", "nanA_1", "patA")
###???
is_invasive_list <- c("source", "source", "source", "source", "SPN23F03800", "SPN23F18530", "SPN23F19730", "rimM", "SPN23F01970", "SPN23F05380", "bacA", "SPN23F22560", "SPN23F13850", "lctO", "PEN", "SPN23F04640", "SPN23F06120", "SPN23F19710", "SPN23F12060", "SPN23F18590", "SPN23F08100", "rpsJ", "SPN23F00900", "SPN23F08400", "SPN23F03000", "SPN23F02350", "SPN23F22250", "SPN23F19070", "SPN23F19710")
df$is_invasive <- ifelse(df$source %in% c("blood","CSF"), "invasive","not_invasive")

for(i in is_invasive_list){
  print(pheamapit("is_invasive",i,df))
}

source_list <- c("AB1B2_GROUPS","strH","SPN23F15600","pyrP","carB","SPN23F17890","SPN23F21730","SPN23F21840","SPN23F15840","pfk","SPN23F18570","clpX","engA")

for(i in source_list){
  print(pheamapit("source",i,df))
}

AB1B2_list <- c(
"accC", "SC_MLST", "ciaH", "SPN23F07690", "SC_MLST", "scpB", "SPN23F06640", "SPN23F13870", "fabZ", "SPN23F07780", "SPN23F10570", "SPN23F08610", "SPN23F20240", "efp", "SPN23F19110", "SPN23F08620", "SPN23F00470", "SPN23F20150", "SPN23F00090", "SPN23F20230", "SPN23F20210", "SPN23F06750", "nusG")

for(i in AB1B2_list){
  print(pheamapit("AB1B2_GROUPS",i,df))
}

SC_MLST_list <- c("SPN23F14460", "comX_1", "trpE", "SPN23F04400", "gki_MLST", "SPN23F03660", "galE_1", "ciaH", "SPN23F13980", "relA", "addB", "SPN23F16040", "SPN23F21780", "aroK", "rpsC", "SPN23F07330", "SPN23F01160", "fmt", "SPN23F12260", "SPN23F22520", "pbp1A", "SPN23F01390")

for(i in SC_MLST_list){
  print(pheamapit("SC_MLST",i,df))
}
