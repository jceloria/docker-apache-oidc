#!/bin/sh

set -xe

cd /etc/apache2

# fix broken paths
mkdir -p /run/apache2
ln -s ../../usr/lib/apache2 modules
ln -s ../../var/log/apache2 logs
ln -s /run/apache2 run

# update httpd.conf
sed -i 's@^#*\(ServerRoot\).*@\1 /etc/apache2@g' httpd.conf
sed -i 's@^#\(ServerName\).*@\1 ${SERVER_NAME}@g' httpd.conf
sed -i 's@^#\(LoadModule.*rewrite_module.*\).*@\1@g' httpd.conf

# move default configuration files out of the way
mkdir /tmp/defaults && mv conf.d/* /tmp/defaults

exit 0
