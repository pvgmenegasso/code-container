.PHONY: build up down restart clean fix-perms purge

IMAGE := pvgm/code-container:local

fix-perms:
	sudo chown -R 1000:1000 ./container-home
	podman unshare chown -R 1000:1000 container-home

build:
	podman compose build

up: fix-perms
	podman compose up -d

down:
	podman compose down

clean:
	podman compose down -v

restart: off up

purge: clean
	@mkdir -p container-home container-home/container-workspace
	@find container-home -mindepth 1 -maxdepth 1 -exec rm -rf -- "{}" \; || true
	podman rm -a
	podman image rm -a
