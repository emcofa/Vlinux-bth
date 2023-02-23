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
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"


#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  cal                           Print out current calendar."
"  uptime                        Print system uptime."
"  greet                         System says hello."
"  loop <min> <max>              Write all numbers between min and max."
"  lower <n n n...>              Write numbers less than 42."
"  reverse <random sentence>     Write sentance reversed."
"  all                           All commands."

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
function badUsage
{
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
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Function for showingh calendar
#
function app-cal
{
    cal -3
}

#
# Function for showing uptime
#
function app-uptime
{
    uptime
}

#
# Function for greeting
#
function app-greet
{
    echo "Hello! Nice to meet you :D"
}

#
# Function for loop
#
function app-loop
{   
    read -r -a array <<< "$*"

    start=${array[0]}
    end=${array[1]}
    for (( i=start; i<=end; i++ )) ; do 
    echo "$i" ;
    done
}

#
# Function for writing out numbers less than 42
#
function app-lower
{   
    args="$*"
    len=${#args[@]}

    for value in $args
    do
    if [[ $value -lt 42 ]]
    then
        echo "$value"
    fi  
    done
}

#
# Function for writing sentance backwards
#
function app-reverse
{   
    arg=$*

    len=${#arg}
    for (( i=len-1; i>=0; i-- ));
    do
    reverse=$reverse${arg:$i:1}
    done
    echo "$reverse"
}

#
# Function for all commands
#
function app-all
{    
    echo "---------------------------------------------------------------------"
    echo "Showing calendar for three months:"
    echo ""
    app-cal "$@"
    echo "---------------------------------------------------------------------"
    echo "Showing uptime:"
    echo ""
    app-uptime "$@"
    echo "---------------------------------------------------------------------"
    echo "Bash says:"
    echo ""
    app-greet "$@"
    echo "---------------------------------------------------------------------"
    echo "Writing out numbers between 1 to 10:"
    echo ""
    app-loop "1 10"
    echo "---------------------------------------------------------------------"
    echo "Writing out numbers lower than 42 from list '1 10 42 41 19 100 86 5':"
    echo ""
    app-lower "1 10 42 41 19 100 86 5"
    echo "---------------------------------------------------------------------"
    echo "Read this sentance backwards:"
    echo ""
    app-reverse "Read this sentance backwards"
    echo "---------------------------------------------------------------------"
}


#
# Process options
#
function main
{
    while (( $# ))
    do
        case "$1" in

            --help | -h)
                usage
                exit 0
            ;;

            --version | -v)
                version
                exit 0
            ;;

            cal \
            | uptime \
            | greet \
            | loop \
            | lower \
            | reverse \
            | all)
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