# Multi-Stage build to compile skopeo and only "copy" to an alpine container
# GO_TAG: 1.14.0
# ALPINE_TAG: 3.10.3
# SKOPEO_VERSION: 0.1.41
# Skopeo Official Repository
# https://github.com/containers/skopeo

FROM golang:1.14.0 as go_make

ENV SKOPEO_VERSION=v0.1.41

RUN mkdir /skopeo && \
    cd /skopeo && \
    wget https://github.com/containers/skopeo/archive/$SKOPEO_VERSION.tar.gz && \
    tar xvf $SKOPEO_VERSION.tar.gz --directory $GOPATH/src/ && \
    cd $GOPATH/src/skopeo* && \
    rm -rf /skopeo && \
    make binary-local-static DISABLE_CGO=1 && \
    cp skopeo /tmp/skopeo

FROM alpine:3.10.3

COPY --from=go_make /tmp/skopeo /usr/local/bin/skopeo
