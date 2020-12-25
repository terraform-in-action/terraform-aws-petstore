# Go parameters
BINARY_NAME=deployment
PACKAGE_NAME=function
all: clean deps build package
server-only: clean server-deps server-build package
clean: 
	cd src/server && go clean
	rm -f ${PACKAGE_NAME}.zip
	rm -rf dist
deps:
	cd src/client && npm install
	cd src/server && go get
build: 
	cd src/client && npm run build
	cd src/server && GOOS=linux go build -o $(BINARY_NAME)
server-deps:
	cd src/server && go get
server-build:
	cd src/server && GOOS=linux go build -o $(BINARY_NAME)
package:
	mkdir -p dist/public
	cp -a src/client/build/* dist/public/
	cp src/server/$(BINARY_NAME) dist/$(BINARY_NAME)
	cd dist && zip -r ${PACKAGE_NAME}.zip public/* $(BINARY_NAME)