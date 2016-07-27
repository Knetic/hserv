default: build
all: package

export GOPATH=$(CURDIR)/
export GOBIN=$(CURDIR)/.temp/

init: clean
	go get ./...
	@mkdir -p ./.output

build: init
	go build -o ./.output/hserv .

test:
	go test
	go test -bench=.

clean:
	@rm -rf ./.output/

fmt:
	@go fmt .
	@go fmt ./src/hserv

dist: build test

	export GOOS=linux; \
	export GOARCH=amd64; \
	go build -o ./.output/hserv64 .

	export GOOS=linux; \
	export GOARCH=386; \
	go build -o ./.output/hserv32 .

	export GOOS=darwin; \
	export GOARCH=amd64; \
	go build -o ./.output/hserv_osx .

	export GOOS=windows; \
	export GOARCH=amd64; \
	go build -o ./.output/hserv.exe .

package: versionTest fpmTest dist

	fpm \
		--log error \
		-s dir \
		-t deb \
		-v $(HSERV_VERSION) \
		-n hserv \
		./.output/hserv64=/usr/local/bin/hserv \
		./docs/hserv.7=/usr/share/man/man7/hserv.7 \
		./autocomplete/hserv=/etc/bash_completion.d/hserv

	fpm \
		--log error \
		-s dir \
		-t deb \
		-v $(HSERV_VERSION) \
		-n hserv \
		-a i686 \
		./.output/hserv32=/usr/local/bin/hserv \
		./docs/hserv.7=/usr/share/man/man7/hserv.7 \
		./autocomplete/hserv=/etc/bash_completion.d/hserv

	@mv ./*.deb ./.output/

	fpm \
		--log error \
		-s dir \
		-t rpm \
		-v $(HSERV_VERSION) \
		-n hserv \
		./.output/hserv64=/usr/local/bin/hserv \
		./docs/hserv.7=/usr/share/man/man7/hserv.7 \
		./autocomplete/hserv=/etc/bash_completion.d/hserv
	fpm \
		--log error \
		-s dir \
		-t rpm \
		-v $(HSERV_VERSION) \
		-n hserv \
		-a i686 \
		./.output/hserv32=/usr/local/bin/hserv \
		./docs/hserv.7=/usr/share/man/man7/hserv.7 \
		./autocomplete/hserv=/etc/bash_completion.d/hserv

	@mv ./*.rpm ./.output/

fpmTest:
ifeq ($(shell which fpm), )
	@echo "FPM is not installed, no packages will be made."
	@echo "https://github.com/jordansissel/fpm"
	@exit 1
endif

versionTest:
ifeq ($(HSERV_VERSION), )

	@echo "No 'HSERV_VERSION' was specified."
	@echo "Export a 'HSERV_VERSION' environment variable to perform a package"
	@exit 1
endif
