#!/bin/sh

set -xe

OPENIDC_VERSION=${OPENIDC_VERSION:-""}

if [[ -z "${OPENIDC_VERSION}" ]]; then
   echo "MUST SET OPENIDC_VERSION env var"
   exit 1
fi

# set URLs
CJOSE_URL="https://github.com/cisco/cjose/archive/latest.tar.gz"
OPENIDC_URL="https://github.com/zmartzone/mod_auth_openidc/releases/download/v${OPENIDC_VERSION}/mod_auth_openidc-${OPENIDC_VERSION}.tar.gz"

# change to temporary working directory
cd /tmp/build

# install Cisco's C library implementing the Javascript Object Signing and Encryption (JOSE) 
curl -# -L ${CJOSE_URL} | tar zxf -
cd cjose* && ./configure --prefix=/usr --with-jansson=/usr --with-openssl=/usr && \
    make && make install && cd -

# install mod_auth_openidc from source
curl -# -L ${OPENIDC_URL} | tar zxf -
cd mod_auth_openidc* && ./autogen.sh && \
    ./configure --with-apxs2=$(which apxs) && make && make install && \
        mv auth_openidc.conf /etc/apache2/conf.d/auth_openidc.conf && cd -
exit 0
