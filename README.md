# sixbysix/phpfpm-mage2

## Overview
A phpfpm container for Magento 2 developer use. Prebuilt with the following tools:
- [composer.phar](https://getcomposer.org)
- [mageconfigsync](https://github.com/punkstar/mageconfigsync)
- [n98-magerun.phar](https://github.com/netz98/n98-magerun)
- [mailcatcher](https://mailcatcher.me/)
- xdebug

## Usage

### Environmental Variables
<dl>
  <dt><strong>UID</strong></dt>
  <dd>This container uses [`gosu`](https://github.com/tianon/gosu) to convert the UID of the container www-data to whatever is required by the host. You should, therefore, pass a `UID` env variable containing the required value.</dd>
  <dt><strong>XDEBUG_IDEKEY</strong></dt>
  <dd>If you're looking using Xdebug for debugging in your IDE (phpstorm, for example) set this value to a unique project key so your IDE can authorise connections.</dd>
  <dt><strong>MAILCATCHER_SENDER</strong></dt>
  <dd>Sender email address for the mailcatcher container</dd>
</dl> 

**docker**
```
docker run --rm -e UID=`id -u` -e XDEBUG_IDEKEY=test-xdebug -it sixbysix-phpfpm-mage1:7.2 /bin/bash
```

**docker-compose**
```
services:
  phpfpm:
    image: sixbysix-phpfpm-mage2:7.0.29
    environment:
      - UID=${PHP_UID}
      - XDEBUG_IDEKEY=${XDEBUG_IDEKEY}
```

### app/etc/env.php 
The magento configuration file (app/etc/env.php) is generated automatically when you start the container.

This feature relies on the presence of a app/etc/env.php.docker template file within the Magento project itself, for example:

```
cat <<EOF
<?php
return [
    'backend' => [
        'frontName' => '$MAGE_ADMIN_URL'
    ],
    'crypt' => [
        'key' => '$MAGE_CRYPT'
    ],
    'session' => [
        'save' => 'files'
    ],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => '$MYSQL_HOST',
                'dbname' => '$MYSQL_DATABASE',
                'username' => '$MYSQL_USER',
                'password' => '$MYSQL_PASSWORD',
                'active' => '1'
            ]
        ]
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default'
        ]
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'developer',
    'cache_types' => [
        'config' => 1,
        'layout' => 0,
        'block_html' => 0,
        'view_files_fallback' => 0,
        'view_files_preprocessing' => 0,
        'collections' => 1,
        'db_ddl' => 1,
        'eav' => 1,
        'full_page' => 0,
        'translate' => 1,
        'config_integration' => 1,
        'config_webservice' => 1,
        'config_integration_api' => 1,
        'compiled_config' => 1,
        'reflection' => 1,
        'customer_notification' => 1,
        'vertex' => 1
    ],
    'cache' => [
        'frontend' => [
            'default' => [

            ]
        ]
    ],
    'install' => [
        'date' => 'Thu, 12 Jan 2017 11:18:28 +0000'
    ]
];

EOF
```

You may inject any env variable required into this file:

```
  phpfpm:
    image: sixbysix-phpfpm-mage2:7.0.29
    volumes_from:
      - codebase
    environment:
      - UID=${PHP_UID}
      - XDEBUG_IDEKEY
      - MYSQL_HOST=db
      - MYSQL_DATABASE
      - MYSQL_USER
      - MYSQL_PASSWORD
```

## Mailcatcher

*See [https://mailcatcher.me](https://mailcatcher.me) for description.*
$MAILCATCHER_SENDER