#!/bin/sh

set -xe

if [[ ! -e /etc/localtime ]]; then
    ln -s /usr/share/zoneinfo/${TZ:=UTC} /etc/localtime
fi

export SERVER_NAME="${SERVER_NAME:=localhost}"
export SERVER_ADMIN="${SERVER_ADMIN:=root@localhost}"
export DOCUMENT_ROOT="${DOCUMENT_ROOT:=/var/www/localhost/htdocs}"

if [[ ! -e /etc/apache2/conf.d/modules.d ]]; then
    mv /tmp/defaults/modules.d /etc/apache2/conf.d
fi

if [[ ! -e /etc/apache2/conf.d/defaults ]]; then
    mv /tmp/defaults /etc/apache2/conf.d/defaults
fi

rm -rf /tmp/defaults 2>&1 >/dev/null

if [[ -f "${CUSTOM_SCRIPT}" ]]; then
    echo "A custom script has been found: ${CUSTOM_SCRIPT}"
    . ${CUSTOM_SCRIPT}
fi

exec /usr/sbin/httpd -DNO_DETACH -DFOREGROUND
