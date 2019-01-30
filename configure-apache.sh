#!/bin/sh

set -xe

# change to temporary working directory
cd /tmp/build

# fix broken paths
mkdir -p /run/apache2
for i in /usr/lib/libxml2.so*; do
    [[ -L $i ]] && sed -i "s#/usr/lib/libxml2.so#$i#g" /etc/apache2/conf.d/proxy-html.conf
done

# update httpd.conf
sed -i 's/^#\(ServerRoot\).*/\1 /etc/apache2/g' /etc/apache2/httpd.conf
sed -i 's/^#\(ServerName\).*/\1 ${SERVER_NAME}/g' /etc/apache2/httpd.conf

# move default configuration files out of the way
mkdir /tmp/defaults && mv /etc/apache2/conf.d/* /tmp/defaults

exit 0
