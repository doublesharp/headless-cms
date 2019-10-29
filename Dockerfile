FROM wordpress:5.2.4-php7.3-fpm-alpine
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

ENV ACF_TO_REST_SRC=https://downloads.wordpress.org/plugin/acf-to-rest-api.3.1.0.zip \
    ACF_EXTENDED_SRC=https://downloads.wordpress.org/plugin/acf-extended.0.7.9.9.9.zip \
    ADVANCED_CUSTOM_FIELDS_SRC=https://downloads.wordpress.org/plugin/advanced-custom-fields.5.8.5.zip \
    ADVANCED_CUSTOM_FIELDS_FONT_AWESOME_SRC=https://downloads.wordpress.org/plugin/advanced-custom-fields-font-awesome.zip \
    AMAZON_S3_AND_CLOUDFRONT_SRC=https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.2.1.zip \
    CUSTOM_POST_TYPE_UI_SRC=https://downloads.wordpress.org/plugin/custom-post-type-ui.1.6.2.zip \
    REDIS_CACHE_SRC=https://downloads.wordpress.org/plugin/redis-cache.1.4.3.zip \
    WP_GRAPHQL_SRC=https://github.com/wp-graphql/wp-graphql/archive/v0.3.6.zip \
    WP_GRAPHIQL_SRC=https://github.com/wp-graphql/wp-graphiql/archive/v1.0.0.zip \
    WP_GRAPHQL_ACF_SRC=https://github.com/wp-graphql/wp-graphql-acf/archive/master.zip \
    WP_GRAPHQL_INSIGHTS_SRC=https://github.com/wp-graphql/wp-graphql-insights/archive/master.zip \
    WP_GRAPHQL_CPT_UI_SRC=https://github.com/wp-graphql/wp-graphql-custom-post-type-ui/archive/v1.1.zip \
    WP_GRAPHQL_JWT_AUTHENTICATION_SRC=https://github.com/wp-graphql/wp-graphql-jwt-authentication/archive/master.zip \
    POLYLANG_SRC=https://downloads.wordpress.org/plugin/polylang.2.6.5.zip \
    POLYLANG_SLUG_SRC=https://github.com/grappler/polylang-slug/archive/master.zip \
    WP_GRAPHQL_POLYLANG_SRC=https://github.com/doublesharp/wp-graphql-polylang/archive/master.zip \
    FAST_USER_SWITCHING_SRC=https://downloads.wordpress.org/plugin/fast-user-switching.zip \
    USER_ROLE_EDITOR_SRC=https://downloads.wordpress.org/plugin/user-role-editor.4.52.zip

# Install WP plugins
COPY config/install-plugins.sh .
RUN source ./install-plugins.sh

# WP theme
COPY config/wordpress/theme/* /usr/src/wordpress/wp-content/themes/headless-cms/

# Configure NGINX
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP
COPY config/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Configure PHP-FPM
COPY config/fpm-pool.conf /usr/local/etc/php/php-fpm.d/zzz_custom.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /usr/conf
COPY config/wordpress/wp-*.php /usr/conf/wordpress/

# wp-content volume
VOLUME /var/www/wp-content

# these files are symlinked to the wordpress config
VOLUME /var/www/wordpress

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"
    
# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/wp-healthcheck.php
