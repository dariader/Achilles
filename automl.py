import h2o
import pandas as pd
import sys

from h2o.automl import H2OAutoML, get_leaderboard
h2o.init()


#target="level"
#column_type_of_data = ["categorical"]*10245
#df = h2o.import_file(path="/media/daria_der/linuxdata/Report/Staphylococcus/saureus/Roary_out/full", col_types=column_type_of_data,header=1)


target = sys.argv[1]
column_type_of_data = int(sys.argv[2])*["categorical"]
df=h2o.import_file(path=sys.argv[3], col_types=column_type_of_data,header=1)
out=sys.argv[4]



#target="group"
#column_type_of_data = ["categorical"]*123
#df = h2o.import_file(path="/media/daria_der/linuxdata/neisseria_phylogeny/w_sg_two_clades/xgboost_input_alleles.tsv", col_types=column_type_of_data,header=1)

#target="group"
#column_type_of_data = ["categorical"]*43283
#df = h2o.import_file(path="concatenated_fasta.csv", col_types=column_type_of_data,header=1)



print(df.dim)
print(df.head)
print(df.tail)
print(df.describe)


## pick a response for the supervised problem
response = target

## the response variable is an integer, we will turn it into a categorical/factor for binary classification
df = df.asfactor()
## use all other columns (except for the name & the response column ("survived")) as predictors
#predictors = df.columns
#del(predictors[8])
#print(predictors)
df[[target]].tail()

train, valid, test = df.split_frame(
    ratios=[0.6,0.2],
    seed=1234,
    destination_frames=['train.hex','valid.hex','test.hex'])
valid.head()

x = train.columns
y = target
x.remove(y)

# Run AutoML for 20 base models (limited to 1 hour max runtime by default)
print("starting ml...")
aml = H2OAutoML(max_models=200, seed=1, nfolds=10, balance_classes=True, max_runtime_secs_per_model=3600, max_runtime_secs=10000000)
aml.train(x=x, y=y, training_frame=train, validation_frame=valid)
print("ml finished, getting leaderboard")
# AutoML Leaderboard
# Optionally edd extra model information to the leaderboard
lb = get_leaderboard(aml, extra_columns='ALL')
print("leaderboard done")



# The leader model is stored here
print("best model iss ..")
print(aml.leader)

# If you need to generate predictions on a test set, you can make
# predictions directly on the `"H2OAutoML"` object, or on the leader
# model object directly
# or:

#print("prediction started")
#preds = aml.leader.predict(test)
#print("prediction done")

#print(preds)


print("getting predicates")

#m = h2o.get_model(lb[0,aml.leader])

#print(m.)
#print(m.varimp(use_pandas=True).as_data_frame())
feature_rating = aml.leader.varimp()
print("writing file..")
file = open(out, "w")
file.write(str(aml.leader))
file.write(str(feature_rating))
file.close()
print("done")

#col_used = h2o.get_frame(my_training_frame)
#print(col_used)

