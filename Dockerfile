FROM alpine:3.8

ENV OPENIDC_VERSION=2.3.10.2

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache --virtual .build-deps apache2-dev apr-dev \
        apr-util-dev autoconf automake build-base curl curl-dev hiredis-dev \
        jansson-dev libc-dev libressl-dev libxml2-dev lua-dev nghttp2-dev \
        pcre-dev perl zlib-dev && \
    apk --no-cache add apache2 apache2-error apache2-http2 apache2-icons \
        apache2-lua apache2-mod-wsgi apache2-proxy apache2-proxy-html \
        apache2-ssl apache2-utils apache2-webdav composer hiredis jansson \
        libressl libxml2 php7 php7-apache2 php7-ctype php7-curl php7-dom \
        php7-gd php7-iconv php7-json php7-mbstring php7-openssl php7-pdo_mysql \
        php7-pdo_sqlite php7-phar php7-session php7-simplexml php7-tokenizer \
        php7-xml php7-xmlreader php7-xmlwriter php7-zip tar zlib-dev && \
    ./install-openidc.sh && ./configure-apache.sh && mv run.sh / && \
    runDeps=$( \
        scanelf -nBR /usr/lib/apache2 /usr/sbin/httpd | \
            awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | \
            xargs -r apk info --installed | sort -u \
    ) && apk del --no-cache .build-deps && apk add --no-cache ${runDeps} && \
    rm -rf /var/cache/apk/* /tmp/build

VOLUME /etc/apache2/conf.d

EXPOSE 80 443

CMD ["/run.sh"]
