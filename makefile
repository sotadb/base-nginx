.DEFAULT_GOAL := build
PACKAGE_NAME := sotadb/nginx
PACKAGE_TIMESTAMP = $(shell /bin/date +%Y%m%d%H%M%S)

build:
	docker build -t "${PACKAGE_NAME}:${PACKAGE_TIMESTAMP}" .
	-docker rmi "${PACKAGE_NAME}:latest"
	docker tag "${PACKAGE_NAME}:${PACKAGE_TIMESTAMP}" "${PACKAGE_NAME}:latest"
