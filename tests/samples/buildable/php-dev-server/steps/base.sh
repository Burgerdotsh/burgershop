#!/usr/bin/env bash

apk --no-cache add \
        libmcrypt-dev \
        freetype libpng libjpeg-turbo freetype-dev \
		libpng-dev libjpeg-turbo-dev \
        wget \
        git \
		openssh \
        nginx \
        ca-certificates \
        supervisor \
        bash \
    && docker-php-ext-install \
        mbstring \
        mysqli \
        pdo_mysql \
        opcache \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /var/www \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require "hirak/prestissimo:^0.3"