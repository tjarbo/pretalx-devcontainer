#!/bin/sh
set -eu

# Start redis for local development if it is not already running.
if command -v service >/dev/null 2>&1; then
    if ! service redis-server status >/dev/null 2>&1; then
        service redis-server start
    fi
elif ! pgrep redis-server >/dev/null 2>&1; then
    redis-server --daemonize yes --pidfile /tmp/redis-server.pid --dir /tmp
fi

exec "$@"
