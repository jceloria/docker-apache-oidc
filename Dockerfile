FROM alpine:3.8

ENV OPENIDC_VERSION=2.3.10.2

COPY . /tmp/build

RUN cd /tmp/build && apk --no-cache add \
        apache2 apache2-dev apache2-error apache2-http2 apache2-icons \
        apache2-lua apache2-mod-wsgi apache2-proxy apache2-proxy-html \
        apache2-ssl apache2-utils apache2-webdav apr-dev apr-util-dev \
        autoconf automake curl curl-dev gcc git hiredis hiredis-dev \
        jansson jansson-dev jq libc-dev libressl libressl-dev \
        libxml2 libxml2-dev lua-dev make nghttp2-dev pcre pcre-dev perl \
        tar zlib-dev && \
    ./install-openidc.sh && ./configure-apache.sh && mv run.sh / && \
    apk --no-cache del *-dev autoconf automake gcc git \
        make perl && \
    scanelf --needed --nobanner --recursive /usr/sbin/httpd | \
        awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | \
        xargs -r apk info --installed | sort -u | xargs apk add --no-cache && \
    rm -rf /var/cache/apk/* /tmp/build

VOLUME /etc/apache2/conf.d

EXPOSE 80 443

CMD ["/run.sh"]
