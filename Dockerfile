FROM alpine:3.13.4

LABEL maintainer="Tonye Jack <jtonye@ymail.com>"

RUN apk add bash git openssh grep sed

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
