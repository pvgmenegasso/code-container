.PHONY: run push stop restart 
DOCKERHUBUSER ?= pvgm
CONTAINERNAME ?= code-container
IMAGE := $(DOCKERHUBUSER)/$(CONTAINERNAME):local
CIDFILE := .$(CONTAINERNAME)-cid
PWD := $(shell pwd)


$(CIDFILE): Dockerfile
	podman build -t $(DOCKERHUBUSER)/$(CONTAINERNAME):local .
	echo built > $(CIDFILE)

run: $(CIDFILE)
	podman run -d --rm -p 8080:8080 --cidfile $(CIDFILE) -v $(PWD)/container-workspace:/home/dev/workspace:z  $(IMAGE)

push: build
	# Use buildx in CI for multi-arch; local single-arch push example
	podman login ghcr.io
	podman push $(DOCKERHUBUSER)/my-image:local ghcr.io/$(IMAGE)

stop:
	podman stop --cidfile $(CIDFILE)
	rm -f $(CIDFILE)

restart: stop run
