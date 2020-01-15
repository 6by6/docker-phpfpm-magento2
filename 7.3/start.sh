#!/bin/bash

usermod -u $UID www-data
groupmod -g $UID www-data

if [ -z "$NO_XDEBUG" ]; then

HOST_IP=`/sbin/ip route | awk '/default/ { print $3 }'`

cat > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini <<- EOF
zend_extension=xdebug.so
EOF

cat >> /usr/local/etc/php/php.ini <<- EOF
access.log = /proc/self/fd/2
error_log = /proc/self/fd/2
xdebug.idekey=$XDEBUG_IDEKEY
xdebug.remote_connect_back=Off
xdebug.remote_enable=On
xdebug.remote_host=$HOST_IP
xdebug.remote_port=9000
xdebug.remote_autostart=true
xdebug.remote_handler=dbgp
EOF
fi

if [ -z "$NO_MAILCATCHER" ]; then
cat >> /usr/local/etc/php/php.ini <<- EOF
sendmail_path=/usr/bin/env catchmail -f $MAILCATCHER_SENDER --smtp-ip $MAILCATCHER_IP --smtp-port 25
EOF
fi

# generate app/etc/env.php
if [ -f "/var/www/app/etc/env.php.docker" ]; then
  gosu www-data bash -c 'eval "$(</var/www/app/etc/env.php.docker)" > /var/www/app/etc/env.php'
else
  echo "Could not create /var/www/app/etc/env.php as there is no template at /var/www/app/etc/env.php.docker"
fi

if [[ "$@" = "php-fpm" ]]; then
  $@
else
  gosu www-data $@
fi