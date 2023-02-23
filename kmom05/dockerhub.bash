#!/usr/bin/env bash

docker network create dbwebb

docker run -d -p 8080:1337 --name myserver --net dbwebb emcofah/vlinux-mazeserver:1.0
docker run -it --name myclient --net dbwebb emcofah/vlinux-mazeclient:1.0


echo "Stopping containers and deleting network..."
docker stop myserver
docker stop myclient
docker network rm dbwebb
docker rm myserver
docker rm myclient
