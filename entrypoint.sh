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

# Setup WordPress config files volume
if [ ! -e /var/www/wordpress/wp-config.php ]; then
  echo 'Setting up wp-config'
  cp /usr/conf/wordpress/wp-config.php /var/www/wordpress
fi

if [ ! -e /var/www/wordpress/wp-healthcheck.php ]; then
  echo 'Setting up wp-healthcheck'
  cp /usr/conf/wordpress/wp-healthcheck.php /var/www/wordpress
fi

WP_SECRETS=$(cat /var/www/wordpress/wp-secrets.php 2>/dev/null)
if ! echo "$WP_SECRETS" | grep -q "SECURE_AUTH_KEY"; then
  # Generate secrets
  echo 'Setting up wp-secrets'
  cp /usr/conf/wordpress/wp-secrets.php /var/www/wordpress
  curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/wordpress/wp-secrets.php
fi

ln -s /var/www/wordpress/wp-config.php /usr/src/wordpress/wp-config.php \
  && ln -s /var/www/wordpress/wp-secrets.php /usr/src/wordpress/wp-secrets.php \
  && ln -s /var/www/wordpress/wp-healthcheck.php /usr/src/wordpress/wp-healthcheck.php

exec "$@"
