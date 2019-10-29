<?php
// our content dir, mapped to a volume
define('WP_CONTENT_DIR', '/var/www/wp-content');

// direct filesystem access, this is ok because it is dockerized
define('FS_METHOD', 'direct');

// only update the core via docker
define('WP_AUTO_UPDATE_CORE', false);

// only update the core via docker
define('WP_DEFAULT_THEME', 'headless-cms');

// set our wordpress table prefix
$table_prefix = getenv('TABLE_PREFIX') ?: 'wp_';

// definie all environment variables
foreach ($_ENV as $key => $value) {
    $capitalized = strtoupper($key);
    if (!defined($capitalized) && !empty($value)) {
        define($capitalized, $value);
    }
}

// define ABSPATH as the location of this file
if (!defined('ABSPATH')) {
  define('ABSPATH', dirname(__FILE__) . '/');
}

define('WP_CACHE', true);
define('WP_REDIS_DOCKERIZED', true);
// define('WP_REDIS_SHOW_STATS', true);

// include secrets (copied in Dockerfile)
require_once(ABSPATH . 'wp-secrets.php');

// include default settings file
require_once(ABSPATH . 'wp-settings.php');
