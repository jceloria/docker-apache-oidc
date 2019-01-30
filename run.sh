#!/bin/sh

set -xe

[[ -f "${CUSTOM_SCRIPT}" ]] && . ${CUSTOM_SCRIPT}

[[ -z "${SERVER_NAME}" ]] && export SERVER_NAME=localhost

if [[ ! -e /etc/apache2/conf.d/defaults ]]; then
    mv /tmp/defaults /etc/apache2/conf.d/defaults
else
    rm -rf /tmp/defaults
fi

exec /usr/sbin/httpd -DNO_DETACH -DFOREGROUND
