# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install common tools (git provided by feature; keep minimal)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        jq \
        less \
        openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Optional: preconfigure git's default branch name
RUN git config --system init.defaultBranch main
