#!/bin/sh

set -xe

mv modules.d /etc/apache2 && cd /etc/apache2

# fix paths
mkdir -p /run/apache2
ln -s ../../usr/lib/apache2 modules
ln -s ../../var/log/apache2 logs
ln -s /run/apache2 run

# move default configuration files out of the way
mkdir -p /tmp/defaults && mv httpd.conf modules.d conf.d/* /tmp/defaults

# load modules from included directory
sed -n '/foo_module/{p;:a;N;/IfModule unixd_module/!ba;s/.*\n/#\nInclude conf.d\/modules.d\/\*.conf\n\n/};p' \
    /tmp/defaults/httpd.conf > httpd.conf

# update minimum required configuration options
sed -i 's@^#*\(ServerRoot\).*@\1 /etc/apache2@g' httpd.conf
sed -i 's@^#\(ServerName\).*@\1 ${SERVER_NAME}@g' httpd.conf
sed -i 's@/var/www/localhost/htdocs@${DOCUMENT_ROOT}@g' httpd.conf

exit 0
