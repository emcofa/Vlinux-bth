#!/usr/bin/env bash

DBWEBB_PORT=${DBWEBB_PORT:-8080}

docker run -it -d -p "$DBWEBB_PORT":1337 -v "$(pwd)"/"$1":/server/data --name myserver emcofah/vlinux-server:1.0
