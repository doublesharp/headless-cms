#!/bin/sh

WP_PLUGINS_DIR=/usr/src/wordpress/wp-content/plugins && \
WP_REPO_BASE=https://downloads.wordpress.org/plugin && \
GQL_REPO_BASE=https://github.com/wp-graphql && \
\
mkdir -p ${WP_PLUGINS_DIR} && \
mkdir -p /tmp/plugins/unzipped && \
echo "Installing default plugins..." && \
\
PLUGIN=acf-to-rest-api && \
curl -sL $ACF_TO_REST_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=acf-extended && \
curl -sL $ACF_TO_REST_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=advanced-custom-fields && \
curl -sL $ACF_EXTENDED_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=amazon-s3-and-cloudfront && \
curl -sL $AMAZON_S3_AND_CLOUDFRONT_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=custom-post-type-ui && \
curl -sL $CUSTOM_POST_TYPE_UI_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=redis-cache && \
curl -sL $REDIS_CACHE_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphql && \
curl -sL $WP_GRAPHQL_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphiql && \
curl -sL $WP_GRAPHIQL_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphql-acf && \
curl -sL $WP_GRAPHQL_ACF_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphql-insights && \
curl -sL $WP_GRAPHQL_INSIGHTS_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphql-custom-post-type-ui && \
curl -sL $WP_GRAPHQL_CPT_UI_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=polylang && \
curl -sL $POLYLANG_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=polylang-slug && \
curl -sL $POLYLANG_SLUG_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
PLUGIN=wp-graphql-polylang && \
curl -sL $WP_GRAPHQL_POLYLANG_SRC -o "/tmp/plugins/${PLUGIN}.zip" && \
unzip "/tmp/plugins/${PLUGIN}.zip" -d /tmp/plugins/unzipped && \
mv /tmp/plugins/unzipped/* "${WP_PLUGINS_DIR}/${PLUGIN}" && \
\
cp /usr/src/wordpress/wp-content/plugins/redis-cache/includes/object-cache.php /usr/src/wordpress/wp-content && \
rm /usr/src/wordpress/wp-content/plugins/hello.php && \
rm -rf /usr/src/wordpress/wp-content/themes/twentysixteen && \
rm -rf /usr/src/wordpress/wp-content/themes/twentyseventeen && \
rm -rf /usr/src/wordpress/wp-content/themes/twentynineteen && \
rm -rf /tmp/plugins && \
clear && \
ls -la /usr/src/wordpress/wp-content/plugins



