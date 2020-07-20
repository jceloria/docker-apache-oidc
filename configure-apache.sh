#!/bin/sh
set -xe

cd /tmp/build

mkdir -p /etc/apache2/conf.d
mv modules.d /etc/apache2/conf.d

cd /etc/apache2

# fix paths
mkdir -p /run/apache2
ln -sf ../../usr/lib/apache2 modules
ln -sf ../../var/log/apache2 logs
ln -sf /run/apache2 run

# save defaults for later
for src in ${PWD}/httpd.conf ${PWD}/conf.d /etc/php7; do
    dst=/tmp/defaults${src%/*}; mkdir -p ${dst}; mv ${src} ${dst}
done && chown -R root:root /tmp/defaults

# fix broken defaults
find /tmp/defaults -name proxy-html.conf | xargs sed -i 's/libxml2.so/libxml2.so.2/g'

# load modules from included directory
sed -n '/foo_module/{p;:a;N;/IfModule unixd_module/!ba;s/.*\n/#\nInclude conf.d\/modules.d\/\*.conf\n\n/};p' \
    /tmp/defaults${PWD}/httpd.conf > httpd.conf

# update configuration
sed -i 's@^#*\(ServerRoot\).*@\1 /etc/apache2@g' httpd.conf
sed -i 's@^#\(ServerName\).*@\1 ${SERVER_NAME}@g' httpd.conf
sed -i 's@^#*\(ServerAdmin\).*@\1 ${SERVER_ADMIN}@g' httpd.conf
sed -i 's@/var/www/localhost/htdocs@${DOCUMENT_ROOT}@g' httpd.conf
sed -i 's@^\(ErrorLog\).*@\1 /dev/stderr@g' httpd.conf
sed -i '/.*#/!s@\(CustomLog\).*@\1 /dev/stdout combined@g' httpd.conf

# generate a snakeoil certificate in case it's needed
openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=State/L=Locality/O=Random Bits/OU=Widgets/CN=localhost/emailAddress=root@localhost" \
    -keyout /etc/ssl/certs/localhost.key \
    -out /etc/ssl/certs/localhost.crt

exit 0
