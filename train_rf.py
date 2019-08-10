from sklearn.ensemble import RandomForestClassifier
import pandas as pd

PATH_OUT = "clean_data/"

df = pd.read_csv(f"{PATH_OUT}/output.csv")
df = df.sample(frac=0.01) # remove this for the actual model
model = RandomForestClassifier(n_estimators=250, max_depth=25)
model.fit(df[df.columns[df.columns != 'target']], df.target)

import pickle
pickle.dump( model, open( "models/model_rf.pkl", "wb" ))