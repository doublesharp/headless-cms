#!/bin/bash

# terminate on errors
set -e

# Check if volume is empty
if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
  echo 'Setting up wp-content volume'
  # Copy wp-content from Wordpress src to volume
  cp -r /usr/src/wordpress/wp-content /var/www/
  chown -R www-data:www-data /var/www/wp-content
fi

if [ ! -e /var/www/wp-content/healthcheck.php ]; then
  echo 'Setting up wp-content/healthcheck.php'
  cp /usr/src/wordpress/wp-content/healthcheck.php /var/www/wp-content
fi

exec "$@"
