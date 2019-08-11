from sklearn.ensemble import RandomForestClassifier
import pandas as pd
PATH_OUT = "clean_data/"

import pickle
model = pickle.load(open("models/model_rf.pkl", "rb"))
df = pd.read_csv(f"{PATH_OUT}/output_test.csv")


test_labels = df.target
predict_labels = model.predict(df[df.columns[df.columns != 'target']])

import numpy as np

# Check that only the two target labels 0,1 are returned...
assert np.max(predict_labels) == 1
assert np.min(predict_labels) == 0

# Check that we get a "reasonable" share of 1s and 0s, model doesn't go "crazy"

treshold = 0.5
assert np.sum(predict_labels)/len(predict_labels) > treshold