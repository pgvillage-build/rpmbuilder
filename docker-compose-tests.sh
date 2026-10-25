#!/bin/bash
#set -x
set -e

docker-compose down --rmi all || echo new install
docker-compose up specgen
docker-compose up rpmbuilder
docker-compose up rpmsigner
