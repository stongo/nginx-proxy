#
# Nginx Proxy
#
FROM alpine:edge

MAINTAINER Marcus Stong, marcus@andyet.net

EXPOSE 80

RUN apk --update add nodejs build-base nginx bash; \
    mkdir /src; \
    mkdir -p /etc/nginx/ssl-keys

ADD nginx.conf /etc/nginx/nginx.conf
ADD vhost.conf /src
ADD run.sh /root/run.sh

RUN chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]