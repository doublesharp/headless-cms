FROM wordpress:5.2.3-php7.3-fpm-alpine
LABEL Maintainer="Justin Silver <justin@secretparty.io>" \
      Description="Headless WordPress: Nginx & PHP-FPM7 based on Alpine Linux."

# install nginx and supervisor to monitor
RUN apk --no-cache add nginx supervisor

# install php extensions
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    # && docker-php-ext-install -j "$(nproc)" name_of_extension \
    && pecl install -o -f redis \
	  && docker-php-ext-enable redis \
    && apk del .phpize-deps

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

ARG VERSION_ACF_TO_REST=3.1.0
ARG VERSION_ADVANCED_CUSTOM_FIELDS=5.8.5
ARG VERSION_ADVANCED_CUSTOM_FIELDS_EXTENDED=0.7.9.9.9
ARG VERSION_AMAZON_S3_AND_CLOUDFRONT=2.2.1
ARG VERSION_CUSTOM_POST_TYPE_UI=1.6.2
ARG VERSION_REDIS_CACHE=1.4.3
ARG VERSION_WP_GRAPHIQL=1.0.0
ARG VERSION_WP_GRAPHQL=0.3.6
# ARG VERSION_WP_GRAPHQL_ACF=0.2.1
ARG VERSION_WP_GRAPHQL_ACF=master
ARG VERSION_WP_GRAPHQL_INSIGHTS=master
ARG VERSION_WP_GRAPHQL_CPT_UI=1.1
ARG VERSION_QTRANSLATE_XT=3.6.3
ARG VERSION_POLYLANG=2.6.5
ARG VERSION_POLYLANG_SLUG=master
ARG VERSION_WP_GRAPHQL_POLYLANG=master

# Install WP plugins
COPY install-plugins.sh .
RUN source ./install-plugins.sh

# WP theme
COPY theme/* /usr/src/wordpress/wp-content/themes/headless-cms/

# Configure NGINX
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP
COPY config/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Configure PHP-FPM
COPY config/fpm-pool.conf /usr/local/etc/php/php-fpm.d/zzz_custom.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# wp-content volume
VOLUME /var/www/wp-content

# WP config / secrets
COPY wp-*.php /usr/src/wordpress/
RUN chown www-data:www-data /usr/src/wordpress/wp-config.php \
  && chmod 640 /usr/src/wordpress/wp-config.php \
  && chown www-data:www-data /usr/src/wordpress/wp-secrets.php \
  && chmod 640 /usr/src/wordpress/wp-secrets.php

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/wp-healthcheck.php
