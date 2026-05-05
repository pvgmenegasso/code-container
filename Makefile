.PHONY: status build up down restart clean fix-perms purge

IMAGE := pvgm/code-container:local
LOCAL_USER := $(shell id -u)
LOCAL_GROUP := $(shell id -g)

define header
	@echo
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo "                                 " $(1)
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
endef

define section
	$(call header, $(1))
	$(2)
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo
endef

status:
	@echo
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo
	@echo PRINTING INFOS ABOUT PODMAN, from lowest to highest abstraction level
	@echo
	$(call section, "ARTIFACTS", podman artifact ls)
	$(call section, "IMAGES", podman images)
	$(call section, "CONTAINERS", podman container list --all)
	$(call section, "PODS", podman pod ps)
	$(call section, "COMPOSE", podman compose ps 2>/dev/null)
	@echo
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------------------------------------------------------------
	@echo



fix-perms:
	sudo chown -R $(LOCAL_USER):$(LOCAL_GROUP) container-home
	podman unshare chown -R "$(LOCAL_USER)":"$(LOCAL_GROUP)" container-home

build:
	podman compose build

up: fix-perms
	podman compose up -d

down:
	podman compose down 2>/dev/null

clean:
	podman compose down -v

restart: down up

purge: clean
	@mkdir -p container-home container-home/container-workspace
	@find container-home -mindepth 1 -maxdepth 1 -exec rm -rf -- "{}" \; || true
	podman rm -a
	podman image rm -a
