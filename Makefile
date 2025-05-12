.PHONY: help lint-check lint-fix format-check format-fix
.DEFAULT_GOAL := help

lint-check: ## Execute lint check
	mint run swiftlint --config .swiftlint.yml

lint-fix: ## Execute lint fix
	mint run swiftlint --config .swiftlint.yml --fix

format-check: ## Execute format check
	mint run swiftformat . --config .swiftformat --dryrun --lint

format-fix: ## Execute format fix
	mint run swiftformat . --config .swiftformat


help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'