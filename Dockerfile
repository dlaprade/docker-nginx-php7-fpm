FROM nginx:1.13.10-alpine

LABEL description="A dockerfile which can be used to run any PHP app"
LABEL build="docker build . -t <SOME_TAG_NAME>"
LABEL run="docker run -p 8000:80 -v \"$PWD\":/app <SOME_TAG_NAME>"
LABEL version="1.0"

RUN apk --no-cache upgrade \
    && apk add --no-cache \
        php7 \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fpm \
        php7-gd \
        php7-iconv \
        php7-imagick \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-openssl \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-phar \
        php7-redis \
        php7-session \
        php7-zip \
        php7-zlib \
        php7-xml \
        php7-simplexml \
        jpegoptim \
        optipng \
        gifsicle \
        libwebp-tools \
        supervisor \
#    && sed -i "s|;*date.timezone =.*|date.timezone = Europe/Oslo|i" /etc/php7/php.ini \
    && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = 50M|i" /etc/php7/php.ini \
    && sed -i "s|;*max_file_uploads =.*|max_file_uploads = 200|i" /etc/php7/php.ini \
    && sed -i "s|;*post_max_size =.*|post_max_size = 100M|i" /etc/php7/php.ini \
    && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php7/php.ini \
    && sed -i "s|error_log = .*|error_log = /proc/self/fd/2|i" /etc/php7/php-fpm.conf \
    && sed -i "s|;catch_workers_output = .*|catch_workers_output = yes|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|user = nobody|user = nobody|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|group = nobody|group = nobody|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|;clear_env = .*|clear_env = no|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|pm = dynamic|pm = ondemand|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|;pm.process_idle_timeout = 10s.*|pm.process_idle_timeout = 60s|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|pm.start_servers = .*|pm.start_servers = 2|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|pm.max_spare_servers = .*|pm.max_spare_servers = 5|i" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s|listen = .*|listen = [::]:9000|i" /etc/php7/php-fpm.d/www.conf  \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && rm composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && mkdir /app \
    && chown -R nobody:nobody /app \
    && rm -rf /var/cache/apk*

COPY files/supervisord.conf /etc/supervisord.conf

RUN echo "upstream php { server 127.0.0.1:9000; }" > /etc/nginx/conf.d/upstream.conf
COPY files/default.conf /etc/nginx/conf.d/default.conf
COPY files/nginx.conf /etc/nginx/nginx.conf

#VOLUME /app
WORKDIR /app

EXPOSE 80
# EXPOSE 9000

#CMD ["/usr/sbin/php-fpm7", "-F", "-c", "/etc/php7"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
