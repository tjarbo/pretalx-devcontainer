# Development Container for pretalx plugins

Development container to develop plugins for pretalx with batteries included.

## Features

* Python 3.14
* Standard toolchain installed like `uv`, `just`.
* Redis server running in the background for local development.
* Automated config generation based on a shared template.
* Easily customizable.

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
* [Pretalx Plugin Development Docs](https://docs.pretalx.org/developer/plugins/)
