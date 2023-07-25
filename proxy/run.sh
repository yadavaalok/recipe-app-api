#!/bin/sh

set -e

envsubst < /etc/nignx/default.conf.tpl > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'