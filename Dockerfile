#
# Nginx Proxy
#
FROM debian:jessie

MAINTAINER Marcus Stong, marcus@andyet.net

EXPOSE 80 443

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 && \
    echo "deb http://www.nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list && \
    apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    mkdir -p /etc/talky-client; \
    touch /etc/talky-client/config.js; \
    mkdir /src; \
    mkdir -p /etc/nginx/ssl-keys

ADD nginx.conf /etc/nginx/nginx.conf
ADD vhost.conf /src
ADD run.sh /root/run.sh

RUN chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]