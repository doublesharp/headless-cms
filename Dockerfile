FROM wordpress:5.3.2-php7.4-fpm-alpine
LABEL Maintainer="Justin Silver <justin@secretparty.io>" \
      Description="Headless WordPress: Nginx & PHP-FPM7 based on Alpine Linux."

# install nginx and supervisor to monitor
RUN apk add --no-cache --update \
    bash jq nginx supervisor

# Create our non-priviledged user that will run wordpress.
RUN set -xe; \
    addgroup --gid 420 -S wordpress; \
    adduser -S -h /home/wordpress -s /bin/sh -u 420 -G wordpress wordpress

# install php extensions
RUN set -xe; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
      # build tools
      autoconf g++ gcc make \
      # lib tools
      bzip2-dev freetype-dev gettext-dev icu-dev imagemagick-dev libintl libjpeg-turbo-dev \
      #  libmcrypt-dev 
      libpng-dev libxslt-dev libzip-dev \
      ; \
    docker-php-ext-install -j$(nproc) \
      bz2 calendar gettext intl opcache pcntl pdo_mysql soap xsl \
      ; \
    pecl channel-update pecl.php.net && \
    pecl install -o -f \
      redis \
      # xdebug \
      ; \
    docker-php-ext-enable \
      redis \
      ; \
    runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
      apk add --virtual .phpexts-rundeps $runDeps; \
      apk del .build-deps

# wp-cli completions
RUN set -xe; \
    mkdir -p ~/.wp-cli/; \
    curl -L https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -o $HOME/.wp-cli/wp-completion.bash; \
    echo "source $HOME/.wp-cli/wp-completion.bash" >> $HOME/.bashrc;

ARG ACF_EXTENDED_SRC=https://downloads.wordpress.org/plugin/acf-extended.0.8.3.1.zip
ARG ADVANCED_CUSTOM_FIELDS_SRC=https://downloads.wordpress.org/plugin/advanced-custom-fields.5.8.7.zip
ARG AMAZON_S3_AND_CLOUDFRONT_SRC=https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.3.1.zip
ARG CUSTOM_POST_TYPE_UI_SRC=https://downloads.wordpress.org/plugin/custom-post-type-ui.1.7.1.zip
ARG REDIS_CACHE_SRC=https://downloads.wordpress.org/plugin/redis-cache.1.5.4.zip
ARG WP_GRAPHQL_SRC=https://github.com/wp-graphql/wp-graphql/archive/v0.4.3.zip
ARG WP_GRAPHIQL_SRC=https://github.com/wp-graphql/wp-graphiql/archive/v1.0.1.zip
ARG WP_GRAPHQL_ACF_SRC=https://github.com/wp-graphql/wp-graphql-acf/archive/master.zip
ARG WP_GRAPHQL_INSIGHTS_SRC=https://github.com/wp-graphql/wp-graphql-insights/archive/master.zip
ARG WP_GRAPHQL_CPT_UI_SRC=https://github.com/wp-graphql/wp-graphql-custom-post-type-ui/archive/v1.1.zip
ARG WP_GRAPHQL_JWT_AUTHENTICATION_SRC=https://github.com/wp-graphql/wp-graphql-jwt-authentication/archive/master.zip
ARG POLYLANG_SRC=https://downloads.wordpress.org/plugin/polylang.2.6.7.zip
ARG POLYLANG_SLUG_SRC=https://github.com/grappler/polylang-slug/archive/master.zip
ARG WP_GRAPHQL_POLYLANG_SRC=https://github.com/doublesharp/wp-graphql-polylang/archive/master.zip

# Install WP plugins
COPY rootfs/usr/local/bin/* /usr/local/bin/
RUN install-plugins.sh

# Configure NGINX
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

WORKDIR /usr/src/wordpress

# Entrypoint to copy wp-content
ENTRYPOINT [ "entrypoint.sh" ]

CMD ["run.sh"]

EXPOSE 80

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/healthcheck.php
