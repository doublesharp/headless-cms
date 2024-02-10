#!/bin/bash

# terminate on errors
set -e

echo "Merging environment variables to NGINX configuration"
templates=("nginx.conf.template" "conf.d.templates/" )
for template in "${templates[@]}"; do
    for filename in /etc/nginx/"$template"*; do
        if [ -f "$filename" ]; then
            newname=$(echo "$filename" | sed 's?\.template$??' | sed 's?\.templates/?/?')
            echo "  Merge $filename --> $newname"
            cat "$filename" |
            envsubst "$(printf '${%s} ' $(env | cut -d'=' -f1))" \
            >"$newname"
        fi
    done
done

echo "Checking NGINX configuration"
nginx -t

# Check if volume is empty
if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
  echo 'wp-content: Setting up wp-content volume'
  # Copy wp-content from Wordpress src to volume
  echo 'wp-content:   Copying /usr/src/wordpress/wp-content to /var/www/'
  cp -r /usr/src/wordpress/wp-content /var/www/
fi

# copy healthcheck.php to wp-content volume
if [ ! -e /var/www/wp-content/healthcheck.php ]; then
  echo 'healthcheck: Setting up wp-content/healthcheck.php'
  echo 'healthcheck:   Copying /usr/src/healthcheck.php to /var/www/wp-content'
  cp /usr/src/wordpress/wp-content/healthcheck.php /var/www/wp-content
  if [ -e /usr/src/wordpress/healthcheck.php ]; then
    echo 'healthcheck:   Removing old link for /usr/src/wordpress/healthcheck.php'
    unlink /usr/src/wordpress/healthcheck.php
  fi
fi

# link wp-content healthcheck
if [ ! -e /usr/src/wordpress/healthcheck.php ]; then
  echo 'healthcheck: Linking /var/www/wp-content/healthcheck.php to /usr/src/wordpress/'
  ln -s /var/www/wp-content/healthcheck.php /usr/src/wordpress/
fi

# echo 'wp-content:   Updating ownership of /var/www/wp-content'
# chown -R $DOCKER_USER:$DOCKER_USER /var/www/wp-content /var/lib/nginx


exec "$@"
