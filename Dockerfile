FROM composer:2 AS build

WORKDIR /app
COPY . .
RUN composer install \
    --no-dev \
    --prefer-dist \
    --optimize-autoloader \
    --no-interaction \
    --no-progress

FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libsqlite3-dev \
        libxml2-dev \
        libzip-dev \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        dom \
        gd \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        pdo_sqlite \
        simplexml \
        sqlite3 \
        xml \
        xmlreader \
        xmlwriter \
        zip \
    && a2enmod expires headers rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY docker/apache-vhost.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html
COPY --from=build /app /var/www/html

RUN mkdir -p /var/www/html/config/sync /var/www/html/var/db /var/www/html/web/sites/default/files \
    && chown -R www-data:www-data /var/www/html/config /var/www/html/var /var/www/html/web/sites/default

EXPOSE 80
