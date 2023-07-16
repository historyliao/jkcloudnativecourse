FROM alpine:3.14

RUN mkdir -p /workdir/conf
COPY httpserver /workdir/httpserver
COPY apiserver.pem /workdir/apiserver.pem
COPY apiserver-key.pem /workdir/apiserver-key.pem

ENTRYPOINT ["/workdir/httpserver"]