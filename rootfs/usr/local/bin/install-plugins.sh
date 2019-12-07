#!/bin/bash

set -xe;

WP_PLUGINS_DIR=/usr/src/wordpress/wp-content/plugins

mkdir -p ${WP_PLUGINS_DIR};
mkdir -p /tmp/plugins/unzipped;
echo "Installing default plugins...";

install_plugin() {
    echo "Installing ${1} from ${2}"
    curl -sL $2 -o "/tmp/plugins/${1}.zip";
    unzip -q "/tmp/plugins/${1}.zip" -d /tmp/plugins/unzipped
    mv /tmp/plugins/unzipped/* "/usr/src/wordpress/wp-content/plugins/${1}"
}

install_plugin "acf-extended" "$ACF_EXTENDED_SRC"
install_plugin "advanced-custom-fields" "$ADVANCED_CUSTOM_FIELDS_SRC"
install_plugin "amazon-s3-and-cloudfront" "$AMAZON_S3_AND_CLOUDFRONT_SRC"
install_plugin "custom-post-type-ui" "$CUSTOM_POST_TYPE_UI_SRC"
install_plugin "redis-cache" "$REDIS_CACHE_SRC"
install_plugin "wp-graphql" "$WP_GRAPHQL_SRC"
install_plugin "wp-graphiql" "$WP_GRAPHIQL_SRC"
install_plugin "wp-graphql-acf" "$WP_GRAPHQL_ACF_SRC"
install_plugin "wp-graphql-insights" "$WP_GRAPHQL_INSIGHTS_SRC"
install_plugin "wp-graphql-custom-post-type-ui" "$WP_GRAPHQL_CPT_UI_SRC"
install_plugin "polylang" "$POLYLANG_SRC"
install_plugin "polylang-slug" "$POLYLANG_SLUG_SRC"
install_plugin "wp-graphql-polylang" "$WP_GRAPHQL_POLYLANG_SRC"

cp /usr/src/wordpress/wp-content/plugins/redis-cache/includes/object-cache.php /usr/src/wordpress/wp-content
rm /usr/src/wordpress/wp-content/plugins/hello.php
rm -rf /usr/src/wordpress/wp-content/themes/twentysixteen
rm -rf /usr/src/wordpress/wp-content/themes/twentyseventeen
rm -rf /usr/src/wordpress/wp-content/themes/twentynineteen
rm -rf /tmp/plugins
