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

SERVER="$(cat server.txt)"

COUNTER=0

#
# Message to display for usage and help.
#
function usage {
    local txt=(
        "Utility $SCRIPT for doing stuff."
        "Usage: $SCRIPT [options] <command> [arguments]"
    
        "Commands available:"
        "  url                Get url to view the server in browser."
        "  view               View all entries."
        "  view url <url>     View all entries containing <url>."
        "  view ip <ip>       View all entries containing <ip>."
        "  use <server>       Sets the server name."

    
        "Options:"
        "  --help, -h         Display the menu."
        "  --version, -h      Display the current version."
        "  --count, -c        Display the number of rows returned."
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
# Count lines
#
function count {
    # echo $3
    COUNTER=1
    app-"$1" "$2" "$3"
}

#
# Sets server
#
function app-use {
    echo "$1" >server.txt
    echo "Server is now:"
    cat server.txt
}

#
# Url to view server in browser
#
function app-url {
    echo "Url to view server in browser: http://localhost:1337/"
}

#
# Route for view data
#
function app-view {
    if [[ "$1" == "url" ]]; then
        url "$2"
    elif [[ "$1" == "ip" ]]; then
        ip "$2"
    else
        if [[ $COUNTER -eq 1 ]]; then
            echo "Number of lines returned:"
            curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data
            sed -i 's/},*/},\n/g' lines.data
            cat lines.data | wc -l
        else
            curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data
            sed -i 's/},*/},/g' lines.data
            sed -i 's/,]$/\n]/' lines.data
            sed -i 's/,/,\n/g' lines.data
            sed -i 's/\[/\[\n/g' lines.data
            sed -i 's/{"ip"/\t{\n\t\t"ip"/g' lines.data
            sed -i 's/"url"/\t\t"url"/g' lines.data
            sed -i 's/"},/"\n\t},/g' lines.data
            sed -i 's/"}/"\n\t}/g' lines.data
            cat lines.data
        fi
    fi
}

#
# Route for showing url
#
function url {
    if [[ $COUNTER -eq 1 ]]; then
        echo "Number of lines returned:"
        curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data/url/"$1"
        sed -i 's/},*/},\n/g' lines.data
        cat lines.data | wc -l
    else
        curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data/url/"$1"
        sed -i 's/},*/},/g' lines.data
        sed -i 's/,]$/\n]/' lines.data
        sed -i 's/,/,\n/g' lines.data
        sed -i 's/\[/\[\n/g' lines.data
        sed -i 's/{"ip"/\t{\n\t\t"ip"/g' lines.data
        sed -i 's/"url"/\t\t"url"/g' lines.data
        sed -i 's/"},/"\n\t},/g' lines.data
        sed -i 's/"}/"\n\t}/g' lines.data
        cat lines.data
    fi
}

#
# Route for showing ip addresses
#
function ip {
    if [[ $COUNTER -eq 1 ]]; then
        echo "Number of lines returned:"
        curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data/ip/"$1"
        sed -i 's/},*/},\n/g' lines.data
        cat lines.data | wc -l
    else
        curl -s -o "lines.data" http://"$SERVER":"$DBWEBB_PORT"/data/ip/"$1"
        sed -i 's/},*/},/g' lines.data
        sed -i 's/,]$/\n]/' lines.data
        sed -i 's/,/,\n/g' lines.data
        sed -i 's/\[/\[\n/g' lines.data
        sed -i 's/{"ip"/\t{\n\t\t"ip"/g' lines.data
        sed -i 's/"url"/\t\t"url"/g' lines.data
        sed -i 's/"},/"\n\t},/g' lines.data
        sed -i 's/"}/"\n\t}/g' lines.data
        cat lines.data
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

        --count | -c)
            shift
            count "$@"
            exit 0
            ;;

        view | \
            use | \
            url)
            command=$1
            shift
            app-"$command" "$@"
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
