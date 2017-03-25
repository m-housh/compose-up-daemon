#!/bin/bash
#
# This can be used as to start a docker-compose application as daemon with
# macOS launchd.  It is pretty basic, so it can be adapted for more advanced
# startup situations.
#


# this can go somewhere else depending on priviledges
# like /var/run/compose-up.d
LOCKDIR=/tmp/compose-up.d


function StartApplication() {

    COMPOSE_FILE=

    while [[ "$1" =~ ^- ]]; do
        case $1 in
            -f | --file) COMPOSE_FILE="$2"; shift;;
            *) ;;
        esac
        shift
    done

    if [ "$COMPOSE_FILE" = "" ]; then
        exit 3
    fi

    mkdir "$LOCKDIR" &>/dev/null

    LOGFILE="$LOCKDIR/$(basename $(dirname COMPOSE_FILE)).log"
    echo "Starting Application..." >> "$LOGFILE"

    # Set a trap to do the cleanup in our ``Shutdown`` function.
    trap Shutdown SIGTERM SIGINT SIGHUP
    
    # start the docker compose application.
    /usr/local/bin/docker-compose -f "$COMPOSE_FILE" up &

    DC_PID=$!  # the process id
    export DC_PID  # make process id available to ``Shutdown``
    wait
    # this is kind of stupid as hopefully the file is about to be removed
    echo "Stopping Application..." >> "$LOGFILE"
    rm -rf "$LOGFILE"
}

function Shutdown() {
    kill -TERM $DC_PID
    wait $DC_PID
}

StartApplication "$@"
