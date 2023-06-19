.PHONY: bin image push deploy

bin:
	GOARCH=amd64 GOOS=linux go build -o httpserver

image: bin
	docker build -f Dockerfile -t ezrealtest/httpserver:test .

push: image
	docker push ezrealtest/httpserver:test 

deploy: image
	docker run -d -p 8080:80 --name test ezrealtest/httpserver:test	