#!/bin/bash

# terminate on errors
set -e

# Check if volume is empty
if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
  echo 'wp-content: Setting up wp-content volume'
  # Copy wp-content from Wordpress src to volume
  echo 'wp-content:   Copying /usr/src/wordpress/wp-content to /var/www/'
  cp -r /usr/src/wordpress/wp-content /var/www/
  echo 'wp-content:   Updating ownership of /var/www/wp-content'
  chown -R www-data:www-data /var/www/wp-content
fi

if [ ! -e /var/www/wp-content/healthcheck.php ]; then
  echo 'healthcheck: Setting up wp-content/healthcheck.php'
  echo 'healthcheck:   Copying /usr/src/healthcheck.php to /var/www/wp-content'
  cp /usr/src/wordpress/wp-content/healthcheck.php /var/www/wp-content
  if [ -e /usr/src/wordpress/healthcheck.php ]; then
    echo 'healthcheck:   Removing old link for /usr/src/wordpress/healthcheck.php'
    unlink /usr/src/wordpress/healthcheck.php
  fi
  echo 'healthcheck:   Linking /var/www/wp-content/healthcheck.php to /usr/src/wordpress/'
  ln -s /var/www/wp-content/healthcheck.php /usr/src/wordpress/
  echo 'healthcheck:   Changing ownership of /usr/src/wordpress/healthcheck.php'
  chown www-data:www-data /usr/src/wordpress/healthcheck.php
fi

exec "$@"
