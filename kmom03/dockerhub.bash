#!/usr/bin/env bash

docker run -it -d -p 8080:80 -v "$1":/var/www/mysite.vlinux.se --name mysite --add-host mysite.vlinux.se:127.0.0.1 emcofah/vlinux-vhost:1.0

# docker run -d -p 8080:80 -v "$(pwd)"/$1:/var/www/"mysite.vlinux.se" --name mysite --add-host mysite.vlinux.se:127.0.0.1 emcofah/vlinux-vhost:1.0

