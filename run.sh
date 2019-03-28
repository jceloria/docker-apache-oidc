#!/bin/sh
set -xe

# set variable dependencies
export SERVER_NAME="${SERVER_NAME:=localhost}"
export SERVER_ADMIN="${SERVER_ADMIN:=root@localhost}"
export DOCUMENT_ROOT="${DOCUMENT_ROOT:=/var/www/localhost/htdocs}"

# copy apache defaults if they don't already exist
find /etc/apache2/conf.d/* >/dev/null 2>&- || {
    src=/tmp/defaults/etc/apache2 dst=/etc/apache2
    (cd ${src} && tar -cf - .) | (cd ${dst} && tar --skip-old-files -xf -)
}

# copy php defaults if they don't already exist
find /etc/php7/* >/dev/null 2>&- || {
    src=/tmp/defaults/etc dst=/etc
    (cd ${src} && tar -cf - php7) | (cd ${dst} && tar --skip-old-files -xf -)
}

# clean up
rm -rf /tmp/defaults

# execute a custom script
if [[ -f "${CUSTOM_SCRIPT}" ]]; then
    echo "A custom script has been found: ${CUSTOM_SCRIPT}"
    . ${CUSTOM_SCRIPT}
fi

exec /usr/sbin/httpd -DNO_DETACH -DFOREGROUND
