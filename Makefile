SHELL:=/bin/bash
YOUR_BUCKET_PATH:=s3://bla/data/

.PHONY: test

dep: ## install python dependencies
	pipenv install

dvc_config: ## init dvc and add the data storage
	dvc init
	dvc remote add -d myremote $(YOUR_BUCKET_PATH)

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
