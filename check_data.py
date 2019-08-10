import pandas as pd

PATH = "data/"
PATH_OUT = "clean_data/"

# Load data
df = pd.read_csv(f'{PATH}/train.csv')

# Check the target is not nan
assert df.target.isna().sum() == 0

# Check the song_id is not nan
assert df.song_id.isna().sum() == 0