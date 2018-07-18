FROM alpine

RUN apk update && \
    apk add chrony

CMD chronyd -n -m -s -l /dev/stdout
