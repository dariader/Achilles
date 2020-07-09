# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 16.04.2020

data=read.csv(file="/media/daria_der/linuxdata/neisseria_virulence/core_genome_R_Frame_transp_fin_is_invasive.csv", sep=" ", header = T)
names(data)
data$Locus <- NULL
data <- data[,1:10]
dataset <- SF.asDecisionTable(dataset = data,decision.attr = 1, indx.nominal = c(1:ncol(data)))
###

disc.Mat <- BC.discernibility.mat.RST(dataset)

###


indx = MV.missingValueCompletion(dataset, type.method = "globalClosestFit")## generate new decision table
# new.decTable <- SF.applyDecTable(decision.table, indx)
dataset <- SF.applyDecTable(dataset,indx)
control <- list(alpha = 1, type.relation = c("tolerance", "eq.1"),type.aggregation = c("t.tnorm", "lukasiewicz"),t.implicator = "lukasiewicz")
reduct.9 <- FS.quickreduct.FRST(dataset, type.method = "fuzzy.discernibility",type.QR = "fuzzy.QR", control = control)

head(dataset)

#data(RoughSetData)
#dataset <- RoughSetData$wine.dt
class(dataset)
## Shuffle the data with set.seed
set.seed(5)
dt.Shuffled <- dataset[sample(nrow(dataset)),]

## Split the data into training and testing
idx <- round(0.8 * nrow(dt.Shuffled))
  wine.tra <-SF.asDecisionTable(dt.Shuffled[1:idx,], decision.attr = 6, indx.nominal = c(6))
  wine.tst <- SF.asDecisionTable(dt.Shuffled[(idx+1):nrow(dt.Shuffled), -ncol(dt.Shuffled)])

## DISCRETIZATION
cut.values <- D.discretization.RST(wine.tra)
d.tra <- SF.applyDecTable(wine.tra, cut.values)
d.tst <- SF.applyDecTable(wine.tst, cut.values)




## FEATURE SELECTION

red.rst <- FS.feature.subset.computation(d.tra,method="quickreduct.frst")
fs.tra <- SF.applyDecTable(d.tra)

## RULE INDUCTION
rules <- RI.indiscernibilityBasedRules.RST(d.tra)

print(rules)
## predicting newdata
pred.vals <- predict(rules, d.tst)
