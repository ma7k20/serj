#!/usr/bin/env sh
set -e

# Ensure Laravel writable/runtime directories exist in container.
mkdir -p storage/framework/{cache,sessions,views} storage/logs bootstrap/cache resources/views
chmod -R 775 storage bootstrap/cache || true

# Do not fail startup on clear commands in ephemeral container filesystems.
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true
php artisan package:discover --ansi

if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
  php artisan migrate --force
fi

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

php artisan serve --host=0.0.0.0 --port="${PORT:-10000}"
