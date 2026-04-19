.PHONY: build run push
DOCKERHUBUSER ?= pvgm

build:
	podman build -t $(DOCKERHUBUSER)/code-container:local .

run:
	podman run --rm -p 3000:3000 $(DOCKERHUBUSER)/code-container:local

push:
	# Use buildx in CI for multi-arch; local single-arch push example
	podman login ghcr.io
	podman push $(DOCKERHUBUSER)/my-image:local ghcr.io/$(DOCKERHUBUSER)/code-container:local
