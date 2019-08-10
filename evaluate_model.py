from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
import pandas as pd
PATH_OUT = "clean_data/"

import pickle
model = pickle.load(open("models/model_rf.pkl", "rb"))
df = pd.read_csv(f"{PATH_OUT}/output_test.csv")


test_labels = df.target
predict_labels = model.predict(df[df.columns[df.columns != 'target']])

acc = accuracy_score(test_labels,predict_labels)

print(classification_report(test_labels, predict_labels))
print(acc)

with open("baseline.txt", "r") as f:
    baseline = f.read()

# Let the pipeline fail if the model does not meet the baseline.
if acc > float(baseline):
    print(f" Accuracy improved from {baseline}->{acc}. Saving new baseline.")
    with open("baseline.txt", "w") as f:
        f.write(str(acc))
else:
    raise ValueError("Accuracy did not approve.")