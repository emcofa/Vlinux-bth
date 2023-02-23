FROM ubuntu:22.04
RUN apt update && \
    apt install -y nano bsdmainutils


WORKDIR kmom02

COPY commands.bash .

ENTRYPOINT ["/bin/bash", "-c", "/kmom02/commands.bash all"]
CMD ["all"]
