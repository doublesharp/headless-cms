FROM wordpress:6.4.3-php8.1-fpm-alpine
LABEL Maintainer="Justin Silver <justin@secretparty.io>" \
  Description="Headless WordPress: Nginx & PHP8-FPM based on Alpine Linux."

# RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ --allow-untrusted gnu-libiconv
# copy from prebuilt
COPY /rootfs/usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN set -xe; \
  # Create our non-priviledged user that will run wordpress.
  addgroup --gid 420 -S wordpress; \
  adduser -S -h /home/wordpress -s /bin/sh -u 420 -G wordpress wordpress; \
  # install php extensions
  apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
  # build tools
  autoconf g++ gcc make \
  # lib tools
  bzip2-dev freetype-dev gettext-dev icu-dev libintl libjpeg-turbo-dev \
  libpng-dev libxslt-dev libzip-dev \
  ; \
  docker-php-ext-install -j$(nproc) \
  bz2 calendar gettext intl opcache pcntl pdo_mysql soap xsl \
  ; \
  pecl channel-update pecl.php.net; \
  pecl install -o -f redis; \
  docker-php-ext-enable redis; \
  # pecl install -o -f xdebug; \
  # docker-php-ext-enable xdebug; \
  runDeps="$( \
  scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
  | tr ',' '\n' \
  | sort -u \
  | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )"; \
  apk add --virtual .phpexts-rundeps $runDeps; \
  apk del .build-deps; \
  # install nginx and supervisor to monitor
  apk add --no-cache --update \
  bash jq nginx supervisor; \
  # wp-cli completions
  mkdir -p ~/.wp-cli/; \
  curl -L https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -o $HOME/.wp-cli/wp-completion.bash; \
  echo "source $HOME/.wp-cli/wp-completion.bash" >> $HOME/.bashrc;

# Install WP plugins
COPY rootfs/usr/local/bin/* /usr/local/bin/
# RUN install-plugins.sh

# WP-CLI
ENV TERM="xterm" \
  PAGER="busybox more"
RUN set -xe; \
  curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp; \
  chmod +x /usr/local/bin/wp; \
  # completions
  mkdir -p ~/.wp-cli/; \
  curl -L https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -o $HOME/.wp-cli/wp-completion.bash; \
  echo "source $HOME/.wp-cli/wp-completion.bash" >> $HOME/.bashrc;

# Configure Supervisor
COPY rootfs/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure NGINX
COPY rootfs/etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure PHP
COPY rootfs/usr/local/etc/php/conf.d/php.ini /usr/local/etc/php/conf.d/zzz-php.ini

# Configure PHP-FPM
COPY rootfs/usr/local/etc/php-fpm.d/* /usr/local/etc/php-fpm.d/
COPY rootfs/usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf

# WP theme
COPY rootfs/usr/src/wordpress/wp-content/themes/headless-cms/* /usr/src/wordpress/wp-content/themes/headless-cms/

# WP default healthcheck, used to copy into 
COPY rootfs/usr/src/wordpress/wp-content/healthcheck.php /usr/src/wordpress/wp-content/

# WP config
COPY rootfs/usr/src/wordpress/wp-config.php /usr/src/wordpress/

RUN chown -R wordpress:wordpress /usr/src/wordpress && \
  chmod 640 /usr/src/wordpress/wp-config.php

# wp-content volume
VOLUME /var/www/wp-content

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
  PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
  PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
  PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

RUN set -xe;\
  cd /usr/local/etc/php/conf.d/; \
  mv docker-php-ext-opcache.ini docker-php-ext-opcache.ini.disabled; \
  mv opcache-recommended.ini opcache-recommended.ini.disabled;

WORKDIR /usr/src/wordpress

# Entrypoint to copy wp-content
ENTRYPOINT [ "entrypoint.sh" ]

CMD ["run.sh"]

EXPOSE 80

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/healthcheck.php
