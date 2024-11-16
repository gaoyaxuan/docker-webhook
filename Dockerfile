# Dockerfile for https://github.com/adnanh/webhook
FROM        golang:alpine AS build
ARG WEBHOOK_VERSION=2.8.2
WORKDIR     /go/src/github.com/adnanh/webhook
RUN         apk add --update -t build-deps curl libc-dev gcc libgcc
RUN         echo "----------------------Current tag: ${WEBHOOK_VERSION}----------------------" && \
            curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/refs/tags/${WEBHOOK_VERSION}.tar.gz && \
            tar -xzf webhook.tar.gz --strip 1
RUN         go get -d -v
RUN         CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/webhook




FROM alpine:3.17

RUN apk --no-cache --no-progress add \
    shadow  \
    tzdata  \
    bash \
    jq \
    gawk \
    sed \
    curl \
    openssl



WORKDIR /app

COPY   --from=build /usr/local/bin/webhook /app/webhook
COPY docker ./docker

RUN  sh ./docker/build.sh &&  \
     rm docker/build.sh


EXPOSE      9000
ENTRYPOINT ["/app/docker/start.sh"]
CMD ["-hooks","/app/hooks.json","-ip","0.0.0.0","-port","9000","-tls-min-version","1.2","-verbose"]

