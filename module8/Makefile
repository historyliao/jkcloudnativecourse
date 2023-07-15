.PHONY: bin image push deploy

bin:
	GOARCH=amd64 GOOS=linux go build -o httpserver

crtgenerator_image: 
	docker build -f Dockerfile.build_crt -t ezrealtest/crtgenerator:v0.0.0 .

push: crtgenerator_image
	docker push ezrealtest/crtgenerator:v0.0.0

deploy: 
	docker run -d -p 8080:80 -v /Users/yyliao/projects/jkcloudnativecourse/module8/crts:/workdir --name test ezrealtest/crtgenerator:v0.0.0 