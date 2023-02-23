FROM ubuntu:22.04

RUN apt update && \
    apt -y install nano \
    cowsay \
    fortune \
    bsdmainutils

WORKDIR scripts

COPY scripts/ .

RUN chmod +x ./*.bash