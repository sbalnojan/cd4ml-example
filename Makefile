SHELL:=/bin/bash
YOUR_BUCKET_PATH:=s3://bla/data/

.PHONY: test

split_train_data: ## Split up data/train.csv to simulate new data incoming, create test data.
	cd data; split  -l 1000000 train.csv split_train
	mv data/train.csv backup/train.csv
	mv data/split_trainaa data/train.csv
	mv data/split_train* backup/
	rm data/test.csv ## only for kaggle submission
	mv backup/split_trainab data/test.csv

reset: ## delete all dvc files, so you can start fresh
	rm -r -f .dvc
	rm -f data.dvc
	rm -f clean_data/preprocess.dvc
	rm -f models/train_rf.dvc

dep: ## install python dependencies
	pipenv install

dvc_config: ## init dvc and add the data storage
	dvc init
	dvc remote add -d myremote $(YOUR_BUCKET_PATH)

dvc_add: ## Add the data dir to dvc.
	dvc add data/
	dvc push

dvc_add_pipes: ## Add the pipelines, then add the output files to dvc
	dvc run -f preprocess.dvc -d preprocess_data.py \
		-d data/members.csv -d data/songs.csv \
	  -d data/train.csv \
	  -o clean_data/output.csv \
	  python preprocess_data.py
	dvc run -f train_rf.dvc -d clean_data/output.csv \
		-d train_rf.py \
		-o models/model_rf.pkl \
		python train_rf.py
	dvc run -f preprocess_test.dvc -d preprocess_data_eval.py \
		-d data/members.csv -d data/songs.csv \
	  -d data/test.csv \
	  -o clean_data/output_test.csv \
	    python preprocess_data_eval.py
	dvc push

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
