FROM golang:1.15 as builder

WORKDIR /go/src/app

COPY . .

RUN go get -d -v ./...

RUN make build

###

FROM ubuntu

LABEL maintainer="Olblak <me@olblak.com>"

VOLUME /tmp

RUN useradd -d /home/updatecli -U -u 1000 -m updatecli

RUN \
  apt-get update && \
  apt-get install -y ca-certificates && \
  apt-get clean && \
  find /var/lib/apt/lists -type f -delete

USER updatecli

WORKDIR /home/updatecli

COPY --from=builder --chown=updatecli:updatecli /go/src/app/bin/updateCli /usr/bin/updatecli

ENTRYPOINT [ "/usr/bin/updatecli" ]

CMD ["--help"]
