<?php
// no need to check for theme updates...
add_filter('auto_update_theme', '__return_false');

add_action('plugins_loaded', function() {
  // auto activate plugins
  foreach (array(
    //'Friendlyr Redis Cache' => 'friendlyr-redis-cache/plugin.php',
    /*
    'Redis Object Cache' => 'redis-cache/redis-cache.php',
    */
    // 'Custom Post Type UI' => 'custom-post-type-ui/custom-post-type-ui.php',
    'Advanced Custom Fields' => 'advanced-custom-fields/acf.php',
    //'Advanced Custom Fields PRO' => 'advanced-custom-fields-pro/acf.php',
    // 'ACF to REST API' => 'acf-to-rest-api/class-acf-to-rest-api.php',
    'WP GraphQL' => 'wp-graphql/wp-graphql.php',
    'WP GraphiQL' => 'wp-graphiql/wp-graphiql.php',
    'WPGraphQL for Advanced Custom Fields' => 'wp-graphql-acf/wp-graphql-acf.php',
    'WPGraphQL Custom Post Type UI' => 'wp-graphql-custom-post-type-ui/wp-graphql-custom-post-type-ui.php',
  ) as $title => $plugin) {
      if (!is_plugin_active( $plugin )) {
          activate_plugin( $plugin );
          add_action( 'admin_notices', function() use ($title) {
              echo '<div class="updated"><p>' . sprintf('<strong>%s</strong> is required & was auto-enabled.', $title) . '</p></div>';
          } );
      }
  }
});