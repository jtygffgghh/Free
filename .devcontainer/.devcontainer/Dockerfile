FROM mcr.microsoft.com/devcontainers/base:debian

RUN apt-get update && apt-get install -y \
    curl unzip docker.io docker-compose openvpn \
    && apt-get clean

WORKDIR /workspace
