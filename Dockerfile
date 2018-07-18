FROM alpine

RUN apk update && \
    apk add chrony

CMD (rm /var/run/chronyd.pid; chronyd -n -m -s -l /dev/stdout)
