oldSignerContainerId = $(shell docker ps -a | grep ' signcrt' | cut -f 1 -d ' ')

.PHONY: httpserver
httpserver:
	CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -o httpserver

.PHONY: build-crtgenerator-image
build-crtgenerator-image: 
	docker build -f Dockerfile.build_crt -t ezrealtest/crtgenerator:v0.0.0 .
	docker image prune -f

.PHONY: push-crtgenerator-image
push-crtgenerator-image: build-crtgenerator-image
	docker push ezrealtest/crtgenerator:v0.0.0

.PHONY: sign-crt
sign-crt: 
ifneq ($(oldSignerContainerId),)
	docker stop $(oldSignerContainerId) && docker rm $(oldSignerContainerId)
endif
	docker run -d -v /Users/yyliao/projects/jkcloudnativecourse/module8/crts:/workdir --name signcrt ezrealtest/crtgenerator:v0.0.0