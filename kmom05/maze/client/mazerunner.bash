#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#

# Name of the script
SCRIPT=$(basename "$0")

# Current version
VERSION="4.0.0"

DBWEBB_PORT=${DBWEBB_PORT:-1337}

SERVER=${SERVER:-myserver}

ID=game-id.data

#
# Message to display for usage and help.
#
function usage {
    local txt=(
        "Utility $SCRIPT for doing stuff."
        "Usage: $SCRIPT [options] <command> [arguments]"
        ""
        "Command:"
        "  init                   Initiera ett spel och spara ned spelets id i en fil."
        "  maps                   Visa vilka kartor som finns att välja bland."
        "  select <#map>          Välj en viss karta via siffra."
        "  enter                  Gå in i första rummet."
        "  info                   Visa information om rummet."
        "  go north               Gå till ett nytt rum, om riktningen stödjs."
        "  go south               Gå till ett nytt rum, om riktningen stödjs."
        "  go east                Gå till ett nytt rum, om riktningen stödjs."
        "  go west                Gå till ett nytt rum, om riktningen stödjs."

        ""
        "Options:"
        "  --help, -h     Print help."
        "  --version, -h  Print version."
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display when bad usage.
#
function badUsage {
    local message="$1"
    local txt=(
        "Please input a command"
        "For an overview of the command, execute:"
        "$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display for version.
#
function version {
    local txt=(
        "$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Route for init game
#
function app-init {
    ID="$(curl -s http://"$SERVER"":""$DBWEBB_PORT""?type=csv" | cut -d"," -f2 | tail -n1)"
    printf "%s\nNew game created. Game ID: $ID%s\n"
    printf "\nUse 'mazerunner maps' to show maps\n\n"
    echo "$ID" >game-id.data
}

#
# Route for showing maps
#
function app-maps {
    info="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/map?type=csv)"
    printf "\nExisting maps\n\n"
    echo "1: maze-of-doom.json"
    echo "2: small-maze.json"
    printf "\n"
    printf "Use 'mazerunner select #' to select map"
    printf "\n\n"
}

#
# Select map
#
function app-select {
    gameId="$(cat game-id.data)"

    if [[ $1 == 1 ]]; then
        map="maze-of-doom.json"
    else
        map="small-maze.json"
    fi
    if [[ $gameId == "" ]]; then
        echo "You need to init a game before selecting a map."
    else
        info="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/map/"$map"?type=csv)"
        printf "%s\n$map selected\n"
        printf "Use 'mazerunner enter' to enter first room.\n\n"
        echo "0" >room-id.data
    fi
}

#
# Enters first room
#
function app-enter {
    gameId="$(cat game-id.data)"
    roomId="$(cat room-id.data)"

    if [[ $gameId == "" || $roomId == "" ]]; then
        echo "You need to select a map berfore entering a room."
    else
        info="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze?type=csv)"
        echo "$info" | cut -d ',' -f 1
        app-info
    fi
}

#
# Information about current room
#
function app-info {
    gameId="$(cat game-id.data)"
    roomId="$(cat room-id.data)"

    description="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$roomId""?type=csv" | cut -d"," -f2 | tail -n1)"
    west="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$roomId""?type=csv" | cut -d"," -f3 | head)"
    east="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$roomId""?type=csv" | cut -d"," -f4 | head)"
    north="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$roomId""?type=csv" | cut -d"," -f6 | head)"
    south="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$roomId""?type=csv" | cut -d"," -f5 | head)"

    if [[ "$description" == "You found the exit" ]]; then
        echo "0" >room-id.data
        echo "" >game-id.data
        echo "$description"
        echo "Init a new game to try again."
    else
        printf "\n"
        echo "Current room:" "$description"
        echo "Directions:"
        echo "$west"
        echo "$east"
        echo "$south"
        echo "$north"
        echo "$roomId" >room-id.data
        printf "\n\nUse 'mazerunner go <direction>' to enter the room ('-' meaning no valid direction)\n\n"
    fi
}

#
# Enters chosen room, if possible
#
function app-go {
    gameId="$(cat game-id.data)"
    getRoomId="$(cat room-id.data)"
    roomId="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/maze/"$getRoomId"/"$1""?type=csv" | cut -d"," -f1 | tail -n1)"
    echo "$roomId" >room-id.data

    if [[ "$getRoomId" == "$roomId" ]]; then
        echo "Room locked. Choose another way."
        echo "Use 'mazerunner info' to see unlocked doors."
    else
        app-info
    fi
}

#
# Process options
#
function main {
    while (($#)); do
        case "$1" in

        --help | -h)
            usage
            exit 0
            ;;

        --version | -v)
            version
            exit 0
            ;;

        --save | -s)
            shift
            save "$@"
            exit 0
            ;;

        \
            init | \
            maps | \
            select | \
            enter | \
            info | \
            go)
            command=$1
            shift
            app-"$command" "$*"
            exit 0
            ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
            ;;

        esac
    done

    badUsage
    exit 1
}

main "$@"
