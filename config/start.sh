#!/usr/bin/env bash
set -ev;

# Refresh cache to reload env vars
# needed to make sure environment variables passed to docker are actually loaded
php artisan optimize:clear;
php artisan config:cache;

# If APP_ENV is "local" then allows dev dependencies (e.g. debug bar)
if [ "$APP_ENV" == "local" ]; then
  echo "Running composer install and yarn run dev (\$APP_ENV=$APP_ENV)";
  composer install --optimize-autoloader;
  yarn run dev;
fi

# run optimizer
php artisan optimize;

# run migrations
if [ -n "$RUN_MIGRATIONS" ]; then
  echo "Running migrations (\$RUN_MIGRATIONS=$RUN_MIGRATIONS)";
  php artisan migrate --force;
fi

# starts supervisor
supervisord -c /etc/supervisor.d/supervisord.ini -l /var/log/supervisord.log -j /var/run/supervisord.pid;
