FROM mcr.microsoft.com/devcontainers/python:3.12

RUN apt update && \
    apt install -y libffi-dev gettext build-essential && \
    pip3 install setuptools wheel Faker

COPY default-scripts /opt/pretalx-devcontainer/default-scripts
