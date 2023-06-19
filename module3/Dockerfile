FROM alpine:3.14

RUN mkdir -p /test
COPY httpserver /test/httpserver

ENTRYPOINT ["/test/httpserver"]