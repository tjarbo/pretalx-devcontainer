# Development Container for pretalx

Development container for pretalx with batteries included.

## Features

* Python 3.14
* Standard toolchain installed like `uv`, `just`.
* Redis server running in the background for local development.

## Redis Server

A Redis server is started in the background when the container starts. You can control it with the following commands:

```bash
# Check if Redis server is running
service redis-server status
# Restart Redis server
service redis-server restart
# Stop Redis server
service redis-server stop
# Start Redis server
service redis-server start
```

## Links

* [Source Code](https://github.com/tjarbo/pretalx-devcontainer/)
* [Pretalx Developer Docs](https://docs.pretalx.org/developer/)
