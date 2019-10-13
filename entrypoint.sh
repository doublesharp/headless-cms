#!/bin/bash

# terminate on errors
set -e

# Check if volume is empty
if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
    echo 'Setting up wp-content volume'
    # Copy wp-content from Wordpress src to volume
    cp -r /usr/src/wordpress/wp-content /var/www/
    chown -R www-data:www-data /var/www
 
fi
if [ ! -e /usr/src/wordpress/wp-secrets.php ]; then
  # Generate secrets
  echo 'Setting up secrets'
  curl -f https://api.wordpress.org/secret-key/1.1/salt/ > /usr/src/wordpress/wp-secrets.php
fi
exec "$@"
