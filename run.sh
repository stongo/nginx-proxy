#!/bin/bash
echo "-- create vhost files"
proxy_envs=$(printenv | grep '^PROXY')
if [ -z "$proxy_envs" ]; then
    echo "ERROR: No Proxy Settings detected"
    echo "Please set environment variables with pattern PROXY_DOMAIN_COM, PROXY_DOMAIN_COM_PEM, PROXY_DOMAIN_COM_KEY"
    exit 1
fi
set_vhost () {
    var=$1
    if [[ $var != *"_SSLPEM"* || $var != *"_SSLKEY"* ]]; then
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
write_ssl () {
    var=$1
    if [[ $var == *"_SSLPEM"* || $var == *"_SSLKEY"* ]]; then
        arr=(${var//=/ })
        name=$(echo "${arr[0]}" | cut -c 6-$(expr ${#arr[0]} - 7 ) | tr '[:upper:]' '[:lower:]' | tr '_' '.')
    fi
    if [[ $var == *"_SSLPEM"* ]]; then
        echo "-- writing ssl pem for $name"
        pem=${arr[1]}
        echo "$pem" | tee /etc/nginx/ssl-keys/${name}.pem
    fi
    if [[ $var == *"_SSLKEY"* ]]; then
        echo "-- writing ssl key for $name"
        key=${arr[1]}
        echo "$key" | tee /etc/nginx/ssl-keys/${name}.key
    fi
}
for value in $proxy_envs; do
    vhost=$(set_vhost $value)
    ssl=$(write_ssl $value)
done
echo "-- starting nginx"
exec 2>&1 /usr/sbin/nginx -c /etc/nginx/nginx.conf