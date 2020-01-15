FROM php:7.3-fpm

WORKDIR /var/www

COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    sendmail-bin \
    sendmail \
    sudo \
    iproute2 \
    mariadb-client \
    ruby \
    ruby-dev \
    libsqlite3-dev \
    libsodium-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=smartlyio/gosu:1.10-alpine /usr/local/bin/gosu /usr/local/bin/gosu

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions
RUN docker-php-ext-install \
  bcmath \
  dom \
  gd \
  intl \
  mbstring \
  pdo_mysql \
  xsl \
  zip \
  soap


# install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install -f libsodium-1.0.17 && docker-php-ext-enable sodium

# install composer
RUN cd /tmp/ && curl -s http://getcomposer.org/installer | php
RUN mv /tmp/composer.phar /usr/local/bin/composer

# install n98-magerun.phar
RUN cd /tmp/ && curl https://files.magerun.net/n98-magerun2.phar > /usr/local/bin/n98 && chmod +x /usr/local/bin/n98

# install https://github.com/punkstar/mageconfigsync/
RUN curl -L https://github.com/punkstar/mageconfigsync/releases/download/0.5.0-beta.1/mageconfigsync-0.5.0-beta.1.phar > /usr/local/bin/mageconfigsync
RUN chmod +x /usr/local/bin/mageconfigsync

RUN usermod -s /bin/bash www-data
RUN usermod -a -G tty www-data

RUN gem install mailcatcher

USER root

ENTRYPOINT ["/start.sh"]
CMD ["php-fpm"]
