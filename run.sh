#!/bin/sh

set -xe

export SERVER_NAME="${SERVER_NAME:=localhost}"
export SERVER_ADMIN="${SERVER_ADMIN:=root@localhost}"
export DOCUMENT_ROOT="${DOCUMENT_ROOT:=/var/www/localhost/htdocs}"

rsync -av --ignore-existing /tmp/defaults/modules.d /etc/apache2/conf.d
rsync -av --ignore-existing /tmp/defaults/php7 /etc
rsync -av --remove-source-files --ignore-existing /tmp/defaults /etc/apache2/conf.d

find /etc/apache2/conf.d /tmp/defaults -depth -type d -exec rmdir {} \; 2>/dev/null

if [[ -f "${CUSTOM_SCRIPT}" ]]; then
    echo "A custom script has been found: ${CUSTOM_SCRIPT}"
    . ${CUSTOM_SCRIPT}
fi

exec /usr/sbin/httpd -DNO_DETACH -DFOREGROUND
