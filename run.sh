#!/bin/bash
echo "-- create vhost files"
proxy_envs=$(printenv | grep '^PROXY')
if [ -z "$proxy_envs" ]; then
    echo "ERROR: No Proxy Settings detected"
    echo "Please set environment variables with pattern PROXY_DOMAIN_COM=target.com"
    exit 1
fi
set_vhost () {
    var=$1
    arr=(${var//=/ })
    name=$(echo "${arr[0]:6}" | tr '[:upper:]' '[:lower:]' | tr '_' '.')
    proxy=${arr[1]}
    echo "-- creating vhost for $name"
    cp /src/vhost.conf /etc/nginx/conf.d/${name}.conf
    sed -i -e "s/{% NGINX_SERVER_NAME %}/$name/g" /etc/nginx/conf.d/${name}.conf
    sed -i -e "s/{% NGINX_PROXY %}/$proxy/g" /etc/nginx/conf.d/${name}.conf
}
for value in $proxy_envs; do
    set_vhost $value
done
echo "-- starting nginx"
exec 2>&1 /usr/sbin/nginx -c /etc/nginx/nginx.conf