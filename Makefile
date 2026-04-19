.PHONY: build run push
DOCKERHUBUSER ?= pvgm

build:
	podman build -t $(DOCKERHUBUSER)/code-container:local .

run: build
	podman run -d --rm -p 8080:8080 $(DOCKERHUBUSER)/code-container:local

push: build
	# Use buildx in CI for multi-arch; local single-arch push example
	podman login ghcr.io
	podman push $(DOCKERHUBUSER)/my-image:local ghcr.io/$(DOCKERHUBUSER)/code-container:local
