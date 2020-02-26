# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 25.02.2020

df = as.data.frame(read.table(file = "/home/daria_der/PycharmProjects/Achilles/test_df_fin.csv", sep = "\t", header = T))
ggplot(data = df, aes_string(x = "Pen_levels", fill = "X97.NEIS0038"))+geom_histogram(position = "dodge")

