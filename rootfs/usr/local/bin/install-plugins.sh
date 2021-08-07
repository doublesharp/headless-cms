#!/bin/bash

# ARG ACF_EXTENDED_SRC=https://downloads.wordpress.org/plugin/acf-extended.0.8.7.4.zip
# ARG ADVANCED_CUSTOM_FIELDS_SRC=https://downloads.wordpress.org/plugin/advanced-custom-fields.5.9.3.zip
# ARG AMAZON_S3_AND_CLOUDFRONT_SRC=https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.5.1.zip
# ARG CUSTOM_POST_TYPE_UI_SRC=https://downloads.wordpress.org/plugin/custom-post-type-ui.1.8.1.zip
# ARG REDIS_CACHE_SRC=https://downloads.wordpress.org/plugin/redis-cache.2.0.15.zip
# ARG WP_GRAPHQL_SRC=https://github.com/wp-graphql/wp-graphql/archive/v1.0.zip
# ARG WP_GRAPHIQL_SRC=https://github.com/wp-graphql/wp-graphiql/archive/v1.0.1.zip
# ARG WP_GRAPHQL_ACF_SRC=https://github.com/wp-graphql/wp-graphql-acf/archive/v0.4.0.zip
# ARG WP_GRAPHQL_INSIGHTS_SRC=https://github.com/wp-graphql/wp-graphql-insights/archive/master.zip
# ARG WP_GRAPHQL_CPT_UI_SRC=https://github.com/wp-graphql/wp-graphql-custom-post-type-ui/archive/v1.1.zip
# ARG WP_GRAPHQL_JWT_AUTHENTICATION_SRC=https://github.com/wp-graphql/wp-graphql-jwt-authentication/archive/v0.4.1.zip
# ARG POLYLANG_SRC=https://downloads.wordpress.org/plugin/polylang.2.9.zip
# ARG POLYLANG_SLUG_SRC=https://github.com/grappler/polylang-slug/archive/master.zip
# ARG WP_GRAPHQL_POLYLANG_SRC=https://github.com/valu-digital/wp-graphql-polylang/archive/v0.5.0.zip

# exit on errors
set -xe

WP_PLUGINS_DIR=/usr/src/wordpress/wp-content/plugins

mkdir -p ${WP_PLUGINS_DIR}
mkdir -p /tmp/plugins/unzipped
echo "🚀 Installing default plugins..."

install_plugin() {
    if [[ ! -z "${2}" ]]; then
        echo "🚧 Installing ${1} from ${2}"
        curl -sL $2 -o "/tmp/plugins/${1}.zip"
        mkdir -p "/tmp/plugins/unzipped/${1}-tmp"
        unzip -q "/tmp/plugins/${1}.zip" -d "/tmp/plugins/unzipped/${1}-tmp/"
        mv "/tmp/plugins/unzipped/${1}-tmp/"* "${WP_PLUGINS_DIR}/${1}"
    else
        echo "💀 Skipping $1"
    fi
}

install_plugin "acf-extended" "$ACF_EXTENDED_SRC" &
install_plugin "advanced-custom-fields" "$ADVANCED_CUSTOM_FIELDS_SRC" &
install_plugin "amazon-s3-and-cloudfront" "$AMAZON_S3_AND_CLOUDFRONT_SRC" &
install_plugin "custom-post-type-ui" "$CUSTOM_POST_TYPE_UI_SRC" &
install_plugin "redis-cache" "$REDIS_CACHE_SRC" &
install_plugin "wp-graphql" "$WP_GRAPHQL_SRC" &
install_plugin "wp-graphiql" "$WP_GRAPHIQL_SRC" &
install_plugin "wp-graphql-acf" "$WP_GRAPHQL_ACF_SRC" &
install_plugin "wp-graphql-insights" "$WP_GRAPHQL_INSIGHTS_SRC" &
install_plugin "wp-graphql-custom-post-type-ui" "$WP_GRAPHQL_CPT_UI_SRC" &
install_plugin "polylang" "$POLYLANG_SRC" &
install_plugin "polylang-slug" "$POLYLANG_SLUG_SRC" &
install_plugin "wp-graphql-polylang" "$WP_GRAPHQL_POLYLANG_SRC" &
wait

echo "🤘 Finished installing default plugins."

cp /usr/src/wordpress/wp-content/plugins/redis-cache/includes/object-cache.php /usr/src/wordpress/wp-content
rm /usr/src/wordpress/wp-content/plugins/hello.php
rm -rf /usr/src/wordpress/wp-content/themes/twentysixteen
rm -rf /usr/src/wordpress/wp-content/themes/twentyseventeen
rm -rf /usr/src/wordpress/wp-content/themes/twentynineteen
rm -rf /tmp/plugins
