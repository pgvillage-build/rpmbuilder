# Build the rpms locally, like the workflows do: make specs rpms [sign]
# IMAGE is the distro release to build for, e.g. IMAGE=rockylinux/rockylinux:10 or IMAGE=opensuse/leap:16.0.
# For podman: make DOCKER=podman COMPOSE=podman-compose ...
IMAGE ?= docker.io/library/fedora:44
DOCKER ?= docker
COMPOSE ?= docker-compose
# the builder image, used by the rpmbuilder and rpmsigner services in docker-compose.yml
export IMAGETAG ?= localhost/rpmbuilder:local

all: specs rpms

.PHONY: specs
specs:
	mkdir -p specs
	chmod 777 specs
	$(COMPOSE) pull specgen
	$(COMPOSE) run --rm specgen

.PHONY: image
image:
	$(DOCKER) build --build-arg BASEIMAGE=$(IMAGE) -t $(IMAGETAG) docker/rpmtools

# builds every spec in specs/ (specgen generates them for the architecture it runs on)
.PHONY: rpms
rpms: image
	rm -rf rpms
	mkdir rpms
	chmod 777 rpms
	$(COMPOSE) run --rm rpmbuilder

# needs GPG_KEY_B64 and GPG_PASSPHRASE (see Secrets in README.md)
.PHONY: sign
sign:
	$(COMPOSE) run --rm rpmsigner
