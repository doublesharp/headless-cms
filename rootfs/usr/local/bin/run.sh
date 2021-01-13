#!/bin/bash

set -e
set -o errexit
set -o nounset
set -o pipefail

_forwardTerm() {
  echo "Caught signal SIGTERM, passing it to child processes..."
  pgrep -P $$ | xargs kill -15 2>/dev/null
  waitf
  exit $?
}

trap _forwardTerm TERM

echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
