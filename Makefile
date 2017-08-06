all: build

IMAGE_NAME="cs5248-ubuntu:latest"

build: Dockerfile setup.sh
	docker build -t $(IMAGE_NAME) .
