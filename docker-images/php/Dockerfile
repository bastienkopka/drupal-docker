FROM php:7.4-fpm-alpine

ARG UID
ARG GID
ARG APP_USER

ENV DRUSH_VERSION="0.8.0"

RUN apk add --update \
    curl \
    wget \
    bash \ 
    git \
    zip \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev

RUN docker-php-ext-install \
    pdo_mysql \
    gd \
    opcache

RUN set eux; \
        [ ! -d /var/www/app ]; \
        mkdir -p /var/www/app; \
        chown www-data:www-data /var/www/app; \
        chmod 777 /var/www/app

# Create user and add user to group www-data
RUN addgroup -g $GID -S $APP_USER; \
    adduser -u $UID -D -S -s /bin/sh -G $APP_USER $APP_USER;

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install drush
RUN composer global require drush/drush:^8.0; \
    drush_url="https://github.com/drush-ops/drush-launcher/releases/download/${DRUSH_VERSION}/drush.phar"; \
    wget -O drush.phar "${drush_url}"; \
    chmod +x drush.phar; \
    mv drush.phar /usr/local/bin/drush;


WORKDIR /var/www/app