#!/bin/bash
echo "-- create vhost files"
proxy_envs=$(printenv | grep '^PROXY')
if [ -z $proxy_envs ]; then
    echo "ERROR: No Proxy Settings detected"
    echo "Please set environment variables with pattern PROXY_DOMAIN_COM, PROXY_DOMAIN_COM_PEM, PROXY_DOMAIN_COM_KEY"
    exit 1
fi
set_vhost () {
    var=$1
    if [[ $var != *"_PEM"* || $var != *"_KEY"* ]]; then
        arr=(${var//=/ })
        name=$(echo "${arr[0]:6}" | tr '[:upper:]' '[:lower:]' | tr '_' '.')
        proxy=${arr[1]}
        key_name="${name}.key"
        pem_name="${name}.pem"
        echo "-- creating vhost for $name"
        cp /src/vhost.conf /etc/nginx/conf.d/${name}.conf
        sed -i -e 's/{% NGINX_SERVER_NAME %}/${name}/g' /etc/nginx/conf.d/${name}.conf
        sed -i -e 's/{% NGINX_PROXY %}/${proxy}/g' /etc/nginx/conf.d/${name}.conf
        sed -i -e 's/{% NGINX_KEY %}/${key_name}/g' /etc/nginx/conf.d/${name}.conf
        sed -i -e 's/{% NGINX_PEM %}/${pem_name}/g' /etc/nginx/conf.d/${name}.conf
        echo "$name"
    fi
}
# TODO: write pem and key files
#write_ssl () {

#}
for value in $proxy_envs; do
    name=$(set_vhost $value)
    echo "name: $name"
done
echo "-- starting nginx"
exec 2>&1 /usr/sbin/nginx -c /etc/nginx/nginx.conf