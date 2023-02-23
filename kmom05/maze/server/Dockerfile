FROM node:10

WORKDIR /server

COPY *.js ./
COPY api.md ./
COPY maps/ ./maps

ENTRYPOINT [ "node", "index.js" ]