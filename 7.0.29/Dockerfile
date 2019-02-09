FROM php:7.0.29-fpm

WORKDIR /var/www

COPY start.sh /start.sh
RUN chmod +x /start.sh

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

RUN usermod -u ${PUID} www-data

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
    mysql-client \
    ruby \
    ruby-dev \
    libsqlite3-dev \
    gosu \
    && rm -rf /var/lib/apt/lists/*

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
  mcrypt \
  pdo_mysql \
  xsl \
  zip \
  soap \


# install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

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

# install https://github.com/punkstar/mageconfigsync/
RUN curl -L https://github.com/punkstar/mageconfigsync/releases/download/0.5.0-beta.1/mageconfigsync-0.5.0-beta.1.phar > /usr/local/bin/mageconfigsync
RUN chmod +x /usr/local/bin/mageconfigsync

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN chmod 777 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN chmod 777 /usr/local/etc/php/php.ini

RUN gem install mailcatcher

ENTRYPOINT ["/start.sh"]

EXPOSE 9000