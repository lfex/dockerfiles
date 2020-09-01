#############################################################################
###   Build Phase   #########################################################
#############################################################################
FROM golang:1.13.15-alpine AS supervisor-builder

ENV GOOS=linux GOARCH=amd64

RUN apk add --update git
RUN git clone https://github.com/ochinchina/supervisord.git && \
    cd supervisord && \
    go build -o /tmp/supervisord_linux_amd64

#############################################################################
###   Build Phase   #########################################################
#############################################################################
FROM lfex/lfe:{{LFE_VERSION}}-{{LATEST_ERL}}-alpine

COPY --from=supervisor-builder /tmp/supervisord_linux_amd64 /usr/bin/supervisord
