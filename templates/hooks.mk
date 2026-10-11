# template: hooks.mk
hooks:
	cp scripts/pre-commit "$(shell git rev-parse --git-path hooks)/pre-commit"
	chmod +x "$(shell git rev-parse --git-path hooks)/pre-commit"
	@echo "Installed $(shell git rev-parse --git-path hooks)/pre-commit"
