all: specs

build_rpms:
	./build_with_docker.sh

.PHONY: specs
specs:
	mkdir -p specs
	chmod 777 specs
	docker-compose pull specgen
	docker-compose up specgen --exit-code-from specgen
