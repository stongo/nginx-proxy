#
# Nginx Proxy
#
FROM alpine:edge

MAINTAINER Marcus Stong, marcus@andyet.net

EXPOSE 80

RUN apk --update add nginx bash && \
    mkdir /src

ADD nginx.conf /etc/nginx/nginx.conf
ADD vhost.conf /src
ADD run.sh /root/run.sh

RUN chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]
