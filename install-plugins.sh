#!/bin/sh

WP_PLUGINS_DIR=/usr/src/wordpress/wp-content/plugins && \
WP_REPO_BASE=https://downloads.wordpress.org/plugin && \
GQL_REPO_BASE=https://github.com/wp-graphql && \
\
mkdir -p ${WP_PLUGINS_DIR} && \
echo "Installing default plugins..." && \
PLUGIN=acf-to-rest-api && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_ACF_TO_REST}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=advanced-custom-fields && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_ADVANCED_CUSTOM_FIELDS}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=advanced-custom-fields-extended && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_ADVANCED_CUSTOM_FIELDS_EXTENDED}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=amazon-s3-and-cloudfront && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_AMAZON_S3_AND_CLOUDFRONT}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=custom-post-type-ui && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_CUSTOM_POST_TYPE_UI}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=redis-cache && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_REDIS_CACHE}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=polylang && \
curl -sL ${WP_REPO_BASE}/${PLUGIN}.${VERSION_POLYLANG}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
\
PLUGIN=wp-graphql && \
curl -sL ${GQL_REPO_BASE}/${PLUGIN}/archive/v${VERSION_WP_GRAPHQL}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHQL} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=wp-graphiql && \
curl -sL ${GQL_REPO_BASE}/${PLUGIN}/archive/v${VERSION_WP_GRAPHIQL}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHIQL} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=wp-graphql-acf && \
curl -sL ${GQL_REPO_BASE}/${PLUGIN}/archive/${VERSION_WP_GRAPHQL_ACF}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHQL_ACF} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=wp-graphql-insights && \
curl -sL ${GQL_REPO_BASE}/${PLUGIN}/archive/${VERSION_WP_GRAPHQL_INSIGHTS}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHQL_INSIGHTS} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=wp-graphql-custom-post-type-ui && \
curl -sL ${GQL_REPO_BASE}/${PLUGIN}/archive/v${VERSION_WP_GRAPHQL_CPT_UI}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHQL_CPT_UI} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=wp-graphql-polylang && \
curl -sL https://github.com/doublesharp/${PLUGIN}/archive/${VERSION_WP_GRAPHQL_POLYLANG}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_WP_GRAPHQL_POLYLANG} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
PLUGIN=polylang-slug && \
curl -sL https://github.com/grappler/${PLUGIN}/archive/${VERSION_POLYLANG_SLUG}.zip -o /tmp/${PLUGIN}.zip && \
unzip /tmp/${PLUGIN}.zip -d ${WP_PLUGINS_DIR} && \
mv ${WP_PLUGINS_DIR}/${PLUGIN}-${VERSION_POLYLANG_SLUG} ${WP_PLUGINS_DIR}/${PLUGIN} && \
\
cp /usr/src/wordpress/wp-content/plugins/redis-cache/includes/object-cache.php /usr/src/wordpress/wp-content && \
rm /usr/src/wordpress/wp-content/plugins/hello.php && \
rm -rf /usr/src/wordpress/wp-content/themes/twentysixteen && \
rm -rf /usr/src/wordpress/wp-content/themes/twentyseventeen && \
rm -rf /usr/src/wordpress/wp-content/themes/twentynineteen && \
rm /tmp/*.zip



