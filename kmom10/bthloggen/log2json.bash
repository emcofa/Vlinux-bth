#!/usr/bin/env bash

if [[ -f data/log.json ]]; then
    rm data/log.json
fi
#Får ut IP-adress och domain
json=$(sed -E -n 's/^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*(http[s]?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,200}).+$/\{\"ip"\: \"\1\"\,\"url"\: \"\2\"\},/p' <../access-50k.log)

printf "[\n%s]" "$json" > data/log.json

#På mac fungerar sed bara om man har "" framför, fungerar inte i container dock
# sed -i 's/,]$/\n]/' data/log.json

#Tar bort sista komma och lägger till en ny rad innan "]"
sed -i '' 's/,]$/\n]/' data/log.json
