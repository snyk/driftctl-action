FROM golang:1.13 as builder

WORKDIR /app
COPY . /app

RUN go get -d -v

# Statically compile our app for use in a distroless container
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -v -o app .

FROM alpine:3.12.4

RUN apk add --update --no-cache curl git bash gnupg jq

COPY --from=builder /app/app /new-relic-report

COPY . .

RUN chmod +x /entrypoint.sh
RUN chmod +x /new-relic-report

ENTRYPOINT ["/entrypoint.sh"]
