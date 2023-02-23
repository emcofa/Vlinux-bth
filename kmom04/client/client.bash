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

# DBWEBB_HOST=${DBWEBB_HOST:-127.0.0.1}
DBWEBB_PORT=${DBWEBB_PORT:-1337}

SAVE=0

#
# Message to display for usage and help.
#
function usage {
    local txt=(
        "Utility $SCRIPT for doing stuff."
        "Usage: $SCRIPT [options] <command> [arguments]"
        ""
        "Command:"
        "  all                           Calls route /all"
        "  names                         Calls route /names"
        "  color <color>                 Calls route /color/<color>"
        "  test <url>                    Checks if server is running."

        ""
        "Options:"
        "  --help, -h     Print help."
        "  --version, -h  Print version."
        "  --save, -s     Save data to file."
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
# Saves data
#
function save {
    SAVE=1
    app-"$1" "$2"
}

#
# Route for showing all
#
function app-all {
    if [[ $SAVE -eq 1 ]]; then
        echo "Saved to saved.data"
        curl -s -o "saved.data" http://localhost:"$DBWEBB_PORT"/all
    else
        curl http://localhost:"$DBWEBB_PORT"/all
    fi
}

#
# Route for showing names
#
function app-names {
    if [[ $SAVE -eq 1 ]]; then
        echo "Saved to saved.data"
        curl -s -o "saved.data" http://localhost:"$DBWEBB_PORT"/names
    else
        curl http://localhost:"$DBWEBB_PORT"/names
    fi
}

#
# Route for showing colors
#
function app-color {
    if [[ $SAVE -eq 1 ]]; then
        echo "Saved to saved.data"
        curl -s -o "saved.data" http://localhost:"$DBWEBB_PORT"/color/"$1"
    else
        curl http://localhost:"$DBWEBB_PORT"/color/"$1"
    fi
}

#
# Tests if server is running or not
#
function app-test {

    if [ -z "$1" ]; then
        arg="http://localhost:$DBWEBB_PORT"
    else
        arg=$1
    fi

    if [[ $SAVE -eq 0 ]]; then
        if [ "$(curl -Is "$arg" | head -n1 | cut -d" " -f2)" == 200 ]; then
            echo "Server is running"
            curl -Is "$arg" | head -n1
        else
            echo "Server is not running"
            curl -Is "$arg" | head -n1
        fi
    fi

    if [[ $SAVE -eq 1 ]]; then
        if [ "$(curl -Is "$arg" | head -n1 | cut -d" " -f2)" == 200 ]; then
            echo "Server is running"
            echo "Saved to saved.data"
            curl -s -o "saved.data" -Is "$arg" | head -n1
        else
            echo "Server is not running"
            echo "Saved to saved.data"
            curl -s -o "saved.data" -Is "$arg" | head -n1
        fi
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

        all | \
            names | \
            color | \
            test)
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
