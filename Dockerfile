# Dockerfile
FROM debian:stable-slim AS base
LABEL org.opencontainers.image.title="codecontainer"
LABEL org.opencontainers.image.description="Minimal image for vscode in container"
LABEL org.opencontainers.image.source="https://github.com/pvgmenegasso/code-container"
LABEL org.opencontainers.image.licenses="MIT"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl git build-essential \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Install code-server (official standalone server)
RUN curl -fsSL https://code-server.dev/install.sh | sh
# Create a non-root user
RUN useradd -m -u 1000 dev && passwd -d dev && adduser dev sudo
RUN chown -R dev home/dev 
USER dev
# RUN code-server --install-extension PedroVinciusGalloMenegasso.dark-violet-theme-vscode
WORKDIR /home/dev/workspace
EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "."]
