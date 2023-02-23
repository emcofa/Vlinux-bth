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

DBWEBB_PORT=${DBWEBB_PORT:-1337}

SERVER=${SERVER:-myserver}

ID=game-id.data

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
# Message to display for usage and help.
#
function app-help {
    local txt=(
        "Utility $SCRIPT for doing stuff."
        "Usage: <command>"
        ""
        "Command:"
        "  help                Visar denna tabell"
        "  info                Visa information om rummet."
        "  north               Gå till ett nytt rum, om riktningen stödjs."
        "  south               Gå till ett nytt rum, om riktningen stödjs."
        "  east                Gå till ett nytt rum, om riktningen stödjs."
        "  west                Gå till ett nytt rum, om riktningen stödjs."

        ""
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Route for init game
#
function app-init {
    echo "**MAZERUNNER**"
    ID="$(curl -s http://"$SERVER"":""$DBWEBB_PORT""?type=csv" | cut -d"," -f2 | tail -n1)"
    printf "%s\nNew game created. Game ID: $ID%s\n"
    echo "$ID" >game-id.data
}

#
# Route for showing maps
#
function app-maps {
    info="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/map?type=csv)"
    printf "\nExisting maps to choose between:\n\n"
    echo "1: maze-of-doom.json"
    echo "2: small-maze.json"
    printf "\n"
}

#
# Select map
#
function app-select {
    gameId="$(cat game-id.data)"

    read -r -p "Select a map: " c
    if [[ $c == 1 ]]; then
        map="maze-of-doom.json"
    elif [[ $c == "quit" ]]; then
        app-quit
    else
        map="small-maze.json"
    fi
    info="$(curl -s http://"$SERVER":"$DBWEBB_PORT"/"$gameId"/map/"$map"?type=csv)"
    printf "%s\n$map selected\n"
    echo "0" >room-id.data
    app-enter
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
        app-info "$info"
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
        echo "Congratulations $description!"
        if [[ $1 = "loop" ]]; then
            app-quit
        fi
    else
        printf "\n"
        echo "Current room:" "$description"
        echo "Directions: ('-' means locked door)"
        echo "$west"
        echo "$east"
        echo "$south"
        echo "$north"
        echo "$roomId" >room-id.data
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
        app-info "$2"
    fi
}

#
# Goes in south direction
#
function app-south {
    app-go "south" "loop"
}

#
# Goes in east direction
#
function app-east {
    app-go "east" "loop"
}

#
# Goes in north direction
#
function app-north {
    app-go "north" "loop"
}

#
# Goes in west direction
#
function app-west {
    app-go "west" "loop"
}

#
# breaks loop
#
function app-quit {
    exit 0
}

#
# Script in enternal loop until "quit" or won game.
#
function app-loop {
    function main {
        clear
        app-init
        app-maps
        app-select
        while :; do
            read -r -p "Enter command: " c
            case "$c" in

            --help | -h)
                usage
                exit 0
                ;;

            \
                info | \
                south | \
                north | \
                west | \
                east | \
                help | \
                quit)
                command=$c
                shift
                app-"$command" "$c"
                ;;
            *)
                badUsage "Option/command not recognized."
                ;;

            esac
        done

        badUsage
        exit 1
    }
    main
}

#
# Process options
#
function main {
    while :; do
        case "$1" in

        loop)
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
