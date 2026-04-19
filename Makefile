.PHONY: build up down restart clean

IMAGE := pvgm/code-container:local

build:
	podman compose build

up: clean build
	podman compose up -d

down:
	podman compose down

restart: down up

clean: down
	@mkdir -p container-home container-home/container-workspace
	@find container-home -mindepth 1 -maxdepth 1 -exec rm -rf -- "{}" \; || true
	podman image prune -a -f || true
