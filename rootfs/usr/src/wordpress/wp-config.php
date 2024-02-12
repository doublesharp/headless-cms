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

if (defined('WP_CLI')) {
  $_SERVER['HTTP_HOST'] = $_SERVER['SERVER_NAME'] = $_ENV['WP_HOME'];
}

// check query string values post_type=elementor_library or page=elementor-app
if (isset($_ENV['ADMIN_HOST']) && $_SERVER['HTTP_HOST'] == $_ENV['ADMIN_HOST'] && ((isset($_GET['action']) && $_GET['action'] == 'elementor') || (isset($_GET['page']) && $_GET['page'] == 'hello-theme-settings'))) {
  define('WP_HOME', 'https://' . $_SERVER['HTTP_HOST']);
  define('WP_SITEURL', 'https://' . $_SERVER['HTTP_HOST']);
}

// define all environment variables
// should include secrets from https://api.wordpress.org/secret-key/1.1/salt/
foreach ($_ENV as $key => $value) {
  $capitalized = strtoupper($key);
  if (!defined($capitalized) && !empty($value)) {
    if ($value === 'true') {
      $value = true;
    } elseif ($value === 'false') {
      $value = false;
    }
    define($capitalized, $value);
  }
}

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && 'https' == $_SERVER['HTTP_X_FORWARDED_PROTO']) {
  $_SERVER['HTTPS'] = 'on';
}

// define ABSPATH as the location of this file
if (!defined('ABSPATH')) {
  define('ABSPATH', dirname(__FILE__) . '/');
}

// include default settings file
require_once(ABSPATH . 'wp-settings.php');
