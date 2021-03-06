# Title     : TODO
# Objective : TODO
# Created by: daria_der
# Created on: 16.04.2020

install.packages("RoughSets")
library("RoughSets")
# NOT RUN {
##############################################################
## A.1 Example: Basic concepts of rough set theory
##############################################################
## Using hiring data set, see RoughSetData
data(RoughSetData)
decision.table <- RoughSetData$hiring.dt
decision.table
## define considered attributes which are first, second, and
## third attributes
attr.P <- c(1,2,3)

## compute indiscernibility relation
IND <- BC.IND.relation.RST(decision.table, feature.set = attr.P)
IND
## compute lower and upper approximations
roughset <- BC.LU.approximation.RST(decision.table, IND)
roughset
## Determine regions
region.RST <- BC.positive.reg.RST(decision.table, roughset)
region.RST
## The decision-relative discernibility matrix and reduct
disc.mat <- BC.discernibility.mat.RST(decision.table, range.object = NULL)
disc.mat
##############################################################
## A.2 Example: Basic concepts of fuzzy rough set theory
##############################################################
## Using pima7 data set, see RoughSetData
data(RoughSetData)
decision.table <- RoughSetData$pima7.dt
decision.table
## In this case, let us consider the first and second attributes
conditional.attr <- c(1, 2)

## We are using the "lukasiewicz" t-norm and the "tolerance" relation
## with "eq.1" as fuzzy similarity equation
control.ind <- list(type.aggregation = c("t.tnorm", "lukasiewicz"),
                    type.relation = c("tolerance", "eq.1"))

## Compute fuzzy indiscernibility relation
IND.condAttr <- BC.IND.relation.FRST(decision.table, attributes = conditional.attr,
                            control = control.ind)

## Compute fuzzy lower and upper approximation using type.LU : "implicator.tnorm"
## Define index of decision attribute
decision.attr = c(9)

## Compute fuzzy indiscernibility relation of decision attribute
## We are using "crisp" for type of aggregation and type of relation
control.dec <- list(type.aggregation = c("crisp"), type.relation = "crisp")

IND.decAttr <- BC.IND.relation.FRST(decision.table, attributes = decision.attr,
                            control = control.dec)

## Define control parameter containing type of implicator and t-norm
control <- list(t.implicator = "lukasiewicz", t.tnorm = "lukasiewicz")

## Compute fuzzy lower and upper approximation
FRST.LU <- BC.LU.approximation.FRST(decision.table, IND.condAttr, IND.decAttr,
              type.LU = "implicator.tnorm", control = control)

## Determine fuzzy positive region and its degree of dependency
fuzzy.region <- BC.positive.reg.FRST(decision.table, FRST.LU)

###############################################################
## B Example : Data analysis based on RST and FRST
## In this example, we are using wine dataset for both RST and FRST
###############################################################
## Load the data
# }
# NOT RUN {


data(RoughSetData)
dataset <- RoughSetData$wine.dt

## Shuffle the data with set.seed
set.seed(5)
dt.Shuffled <- dataset[sample(nrow(dataset)),]

## Split the data into training and testing
idx <- round(0.8 * nrow(dt.Shuffled))
  wine.tra <-SF.asDecisionTable(dt.Shuffled[1:idx,],
decision.attr = 14, indx.nominal = 14)
  wine.tst <- SF.asDecisionTable(dt.Shuffled[
 (idx+1):nrow(dt.Shuffled), -ncol(dt.Shuffled)])

## DISCRETIZATION
cut.values <- D.discretization.RST(wine.tra,
type.method = "global.discernibility")
d.tra <- SF.applyDecTable(wine.tra, cut.values)
d.tst <- SF.applyDecTable(wine.tst, cut.values)




## FEATURE SELECTION
red.rst <- FS.feature.subset.computation(d.tra,
  method="quickreduct.rst")
fs.tra <- SF.applyDecTable(d.tra, red.rst)

## RULE INDUCTION
rules <- RI.indiscernibilityBasedRules.RST(d.tra,
  red.rst)

## predicting newdata
pred.vals <- predict(rules, d.tst)

#################################################
## Examples: Data analysis using the wine dataset
## 2. Learning and prediction using FRST
#################################################

## FEATURE SELECTION
reduct <- FS.feature.subset.computation(wine.tra,
 method = "quickreduct.frst")

## generate new decision tables
wine.tra.fs <- SF.applyDecTable(wine.tra, reduct)
wine.tst.fs <- SF.applyDecTable(wine.tst, reduct)

## INSTANCE SELECTION
indx <- IS.FRIS.FRST(wine.tra.fs,
 control = list(threshold.tau = 0.2, alpha = 1))

## generate a new decision table
wine.tra.is <- SF.applyDecTable(wine.tra.fs, indx)

## RULE INDUCTION (Rule-based classifiers)
control.ri <- list(
 type.aggregation = c("t.tnorm", "lukasiewicz"),
 type.relation = c("tolerance", "eq.3"),
 t.implicator = "kleene_dienes")

decRules.hybrid <- RI.hybridFS.FRST(wine.tra.is,
  control.ri)

## predicting newdata
predValues.hybrid <- predict(decRules.hybrid,
  wine.tst.fs)

#################################################
## Examples: Data analysis using the wine dataset
## 3. Prediction using fuzzy nearest neighbor classifiers
#################################################

## using FRNN.O
control.frnn.o <- list(m = 2,
  type.membership = "gradual")

predValues.frnn.o <- C.FRNN.O.FRST(wine.tra.is,
  newdata = wine.tst.fs, control = control.frnn.o)

## Using FRNN
control.frnn <- list(type.LU = "implicator.tnorm",k=20,
  type.aggregation = c("t.tnorm", "lukasiewicz"),
  type.relation = c("tolerance", "eq.1"),
  t.implicator = "lukasiewicz")

predValues.frnn <- C.FRNN.FRST(wine.tra.is,
  newdata = wine.tst.fs, control = control.frnn)

## calculating error
real.val <- dt.Shuffled[(idx+1):nrow(dt.Shuffled),
  ncol(dt.Shuffled), drop = FALSE]

err.1 <- 100*sum(pred.vals!=real.val)/nrow(pred.vals)
err.2 <- 100*sum(predValues.hybrid!=real.val)/
  nrow(predValues.hybrid)
err.3 <- 100*sum(predValues.frnn.o!=real.val)/
  nrow(predValues.frnn.o)
err.4 <- 100*sum(predValues.frnn!=real.val)/
  nrow(predValues.frnn)

cat("The percentage error = ", err.1, "\n")
cat("The percentage error = ", err.2, "\n")
cat("The percentage error = ", err.3, "\n")
cat("The percentage error = ", err.4, "\n")
# }
####

data(iris)
 set.seed(2)

 irisShuffled <- iris[sample(nrow(iris)),]
 ## transform into numeric values
 irisShuffled[,5] <- unclass(irisShuffled[,5])
 iris.training <- irisShuffled[1:105,]
 real.iris <- matrix(irisShuffled[106:nrow(irisShuffled),5], ncol = 1)
 colnames(iris.training) <- c("Sepal.Length", "Sepal.Width", "Petal.Length",
                        "Petal.Width", "Species")
 decision.table <- SF.asDecisionTable(dataset = iris.training, decision.attr = 5, indx.nominal = c(5))

 ## Define newdata for testing
 tst.iris <- SF.asDecisionTable(dataset = irisShuffled[106:nrow(irisShuffled),1:4])

 ###### perform FRNN algorithm using lower/upper approximation:
 ###### Implicator/tnorm based approach
 control <- list(type.LU = "implicator.tnorm", k = 20,
                 type.aggregation = c("t.tnorm", "lukasiewicz"),
                 type.relation = c("tolerance", "eq.1"), t.implicator = "lukasiewicz")
 res.1 <- C.FRNN.FRST(decision.table = decision.table, newdata = tst.iris,
                              control = control)

 ###### perform FRNN algorithm using VQRS
 control <- list(type.LU = "vqrs", k = 20, q.some = c(0.1, 0.6), q.most = c(0.2, 1),
                  type.relation = c("tolerance", "eq.1"),
                  type.aggregation = c("t.tnorm","lukasiewicz"))
 res.2 <- C.FRNN.FRST(decision.table = decision.table, newdata = tst.iris,
                              control = control)

 ## error calculation
 err.1 = 100*sum(real.iris!=res.1)/nrow(real.iris)
 err.2 = 100*sum(real.iris!=res.2)/nrow(real.iris)

print("FRNN: percentage Error on Iris: ")
print(err.1)
print(err.2)