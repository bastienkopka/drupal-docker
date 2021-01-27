<?php

/**
 * Database settings:
 */
$databases['default']['default'] = array (
  'database' => '_MYSQL_DATABASE_',
  'username' => '_MYSQL_USER_',
  'password' => '_MYSQL_PASS_',
  'prefix' => '',
  'host' => '_MYSQL_HOST_',
  'port' => '_MYSQL_PORT_',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);

/**
 * Location of configuration files.
 */
$config_directories = array(
  CONFIG_SYNC_DIRECTORY => '../config/sync',
);