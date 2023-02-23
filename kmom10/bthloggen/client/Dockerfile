FROM ubuntu:22.04

RUN apt update && apt install -y curl sed

WORKDIR /client

COPY bthloggen.bash ./

COPY server.txt ./

RUN chmod +x ./*.bash