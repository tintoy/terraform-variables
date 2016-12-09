VERSION = 0.1
VERSION_INFO_FILE = ./version-info.go

BIN_DIRECTORY   = _bin
EXECUTABLE_NAME = terraform-variables
DIST_ZIP_PREFIX = $(EXECUTABLE_NAME).v$(VERSION)

REPO_BASE     = github.com/tintoy
REPO_ROOT     = $(REPO_BASE)/terraform-variables

default: fmt build test

fmt:
	go fmt $(REPO_ROOT)/...

clean:
	rm -rf $(BIN_DIRECTORY) $(VERSION_INFO_FILE)
	go clean $(REPO_ROOT)/...

# Peform a development (current-platform-only) build.
dev: version fmt
	go build -o $(BIN_DIRECTORY)/$(EXECUTABLE_NAME) $(REPO_ROOT)

# Perform a full (all-platforms) build.
build: version build-windows64 build-windows32 build-linux64 build-mac64

build-windows64: version
	GOOS=windows GOARCH=amd64 go build -o $(BIN_DIRECTORY)/windows-amd64/$(EXECUTABLE_NAME).exe

build-windows32: version
	GOOS=windows GOARCH=386 go build -o $(BIN_DIRECTORY)/windows-386/$(EXECUTABLE_NAME).exe

build-linux64: version
	GOOS=linux GOARCH=amd64 go build -o $(BIN_DIRECTORY)/linux-amd64/$(EXECUTABLE_NAME)

build-mac64: version
	GOOS=darwin GOARCH=amd64 go build -o $(BIN_DIRECTORY)/darwin-amd64/$(EXECUTABLE_NAME)

# Produce archives for a GitHub release.
dist: build
	cd $(BIN_DIRECTORY)/windows-386 && \
		zip -9 ../$(DIST_ZIP_PREFIX).windows-386.zip $(EXECUTABLE_NAME).exe
	cd $(BIN_DIRECTORY)/windows-amd64 && \
		zip -9 ../$(DIST_ZIP_PREFIX).windows-amd64.zip $(EXECUTABLE_NAME).exe
	cd $(BIN_DIRECTORY)/linux-amd64 && \
		zip -9 ../$(DIST_ZIP_PREFIX).linux-amd64.zip $(EXECUTABLE_NAME)
	cd $(BIN_DIRECTORY)/darwin-amd64 && \
		zip -9 ../$(DIST_ZIP_PREFIX)-darwin-amd64.zip $(EXECUTABLE_NAME)

test: fmt
	go test -v $(REPO_ROOT)

testall: 
	go test -v $(REPO_ROOT)/...

version: $(VERSION_INFO_FILE)

$(VERSION_INFO_FILE): Makefile
	@echo "Update version info: v$(VERSION)"
	@echo "package main\n\n// ProviderVersion is the current version of the terraform-variables tool.\nconst ProviderVersion = \"v$(VERSION) (`git rev-parse HEAD`)\"" > $(VERSION_INFO_FILE)
