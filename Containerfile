FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

RUN apt update && \
    apt install -y libffi-dev gettext build-essential && \
    pip3 install setuptools wheel

COPY default-scripts /opt/pretalx-devcontainer/default-scripts
