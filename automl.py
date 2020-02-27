import h2o
from h2o.automl import H2OAutoML, get_leaderboard
h2o.init()


column_type_of_data = ["categorical"]*42821
df = h2o.import_file(path="corrected", col_types=column_type_of_data,header=1)
print(df.dim)
print(df.head)
print(df.tail)
print(df.describe)


## pick a response for the supervised problem
response = "penicillin"

## the response variable is an integer, we will turn it into a categorical/factor for binary classification
df = df.asfactor()
## use all other columns (except for the name & the response column ("survived")) as predictors
#predictors = df.columns
#del(predictors[8])
#print(predictors)
df[["penicillin"]].tail()

train, valid, test = df.split_frame(
    ratios=[0.6,0.2],
    seed=1234,
    destination_frames=['train.hex','valid.hex','test.hex'])
valid.head()




# Run AutoML for 20 base models (limited to 1 hour max runtime by default)
aml = H2OAutoML(max_models=20, seed=1)
aml.train(x=x, y=y, training_frame=train)

# AutoML Leaderboard
lb = aml.leaderboard

# Optionally edd extra model information to the leaderboard
lb = get_leaderboard(aml, extra_columns='ALL')



# The leader model is stored here
aml.leader

# If you need to generate predictions on a test set, you can make
# predictions directly on the `"H2OAutoML"` object, or on the leader
# model object directly

preds = aml.predict(test)

# or:
preds = aml.leader.predict(test)