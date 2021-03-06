.DEFAULT_GOAL := build

BINARY=qk
VERSION=$(shell git describe --abbrev=0 --tags 2> /dev/null || echo "0.1.0")
BUILD=$(shell git rev-parse HEAD 2> /dev/null || echo "undefined")
LDFLAGS=-ldflags "-X main.Version=$(VERSION) -X main.Build=$(BUILD)"

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build
	CGO_ENABLED=0 go build -o $(BINARY) $(LDFLAGS) ./cmd/qk

.PHONY: install
install: ## Build and install
	CGO_ENABLED=0 go install $(LDFLAGS) ./cmd/qk

.PHONY: release
release: ## Create a new release on Github
	VERSION=$(VERSION) BUILD=$(BUILD) goreleaser

.PHONY: snapshot
snapshot: ## Create a new snapshot release
	VERSION=$(VERSION) BUILD=$(BUILD) goreleaser --snapshot --rm-dist

.PHONY: test
test: ## Run the test suite
	go test ./...

.PHONY: clean
clean: ## Remove the binary
	if [ -f $(BINARY) ] ; then rm $(BINARY) ; fi