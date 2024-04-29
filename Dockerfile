FROM golang:1.22-alpine AS builder

RUN apk update && \
    apk add --no-cache git ca-certificates tzdata && update-ca-certificates

WORKDIR $GOPATH/src/compile/belajardeployalterra
COPY . .

RUN go mod download
RUN go mod verify

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/belajardeployalterra .

FROM alpine:3.16

RUN apk update

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /go/bin/belajardeployalterra /root/

ENTRYPOINT [ "/root/belajardeployalterra" ]

EXPOSE 1323

