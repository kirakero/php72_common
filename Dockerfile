FROM php:7.2.25-apache
MAINTAINER Paul Redmond

ENV DEBIAN_FRONTEND noninteractive
ENV DBUS_SESSION_BUS_ADDRESS /dev/null

# Install GD and opcache
# opcache is configured by default for development
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        wget \
        libxml2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install -j$(nproc) iconv gd opcache mbstring pdo pdo_mysql bcmath zip soap

RUN a2enmod rewrite expires
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Composer Globals
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

WORKDIR /srv/app



