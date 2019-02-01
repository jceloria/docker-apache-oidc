#!/bin/sh

set -xe

[[ -f "${CUSTOM_SCRIPT}" ]] && . ${CUSTOM_SCRIPT}

[[ -z "${SERVER_NAME}" ]] && export SERVER_NAME="localhost"
[[ -z "${SERVER_ADMIN}" ]] && export SERVER_ADMIN="root@localhost"
[[ -z "${DOCUMENT_ROOT}" ]] && export DOCUMENT_ROOT="/var/www/localhost/htdocs"

if [[ ! -e /etc/apache2/conf.d/modules.d ]]; then
    mv /tmp/defaults/modules.d /etc/apache2/conf.d
fi

if [[ ! -e /etc/apache2/conf.d/defaults ]]; then
    mv /tmp/defaults /etc/apache2/conf.d/defaults
fi

rm -rf /tmp/defaults 2>&1 >/dev/null

exec /usr/sbin/httpd -DNO_DETACH -DFOREGROUND
