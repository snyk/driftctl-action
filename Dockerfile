FROM alpine:3.12.4

RUN apk add --update --no-cache curl git bash gnupg

COPY . .

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
