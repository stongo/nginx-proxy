# Nginx Proxy

A SSL terminating reverse proxy. Reads environment variables to create vhosts

## Expected Environment Variables

### `PROXY_SERVER_NAME=proxytarget.com`

Suffix PROXY_ with the server name to listen to. Value should be set to where you want to proxy to

For https://stongo.com to proxy to http://someother.com `PROXY_STONGO_COM=someother.com`

### `PROXY_SERVER_NAME_SSLKEY=mysslkey`

SSL key used for SSL termination

### `PROXY_SERVER_NAME_SSLPEM=mysslpem`

SSL pem used for SSL termination

## Run

`docker run -e PROXY_URL_COM='someother.com/' -e PROXY_URL_COM_SSLKEY="$SSL_KEY" -e PROXY_URL_COM_SSLPEM="$SSL_PEM" -p 443:443 nginx-proxy`