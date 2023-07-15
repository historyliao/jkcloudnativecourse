FROM alpine:3.14

RUN mkdir -p /test
COPY httpserver /test/httpserver
COPY apiserver.pem /test/apiserver.pem
COPY apiserver-key.pem /test/apiserver-key.pem

ENTRYPOINT ["/test/httpserver"]