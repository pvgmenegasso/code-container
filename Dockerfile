# Dockerfile
FROM docker.io/debian:stable-slim AS base
LABEL org.opencontainers.image.title="codecontainer"
LABEL org.opencontainers.image.description="Minimal image for vscode in container"
LABEL org.opencontainers.image.source="https://github.com/pvgmenegasso/code-container"
LABEL org.opencontainers.image.licenses="MIT"
ARG CODE_RELEASE
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl git build-essential sudo

# Install code-server (official standalone server)
RUN if [ -z ${CODE_RELEASE+x} ]; then \
    CODE_RELEASE=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||'); \
  fi && \
  curl -o \
    /tmp/code-server.tar.gz -L \
    "https://github.com/coder/code-server/releases/download/v${CODE_RELEASE}/code-server-${CODE_RELEASE}-linux-amd64.tar.gz" && \
  mkdir -p /app/code-server && \
  tar xf /tmp/code-server.tar.gz -C \
    /app/code-server --strip-components=1 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** clean up ****" && \
  apt-get clean && \
  rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Create a non-root user
RUN useradd -m -u 1000 dev && passwd -d dev && adduser dev sudo
RUN chown -R dev /app/code-server
RUN chmod -R +rwx /app/code-server/bin
USER dev
# RUN code-server --install-extension PedroVinciusGalloMenegasso.dark-violet-theme-vscode
WORKDIR /home/dev
EXPOSE 8080
CMD ["/app/code-server/bin/code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "."]
