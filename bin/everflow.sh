#!/bin/bash
#
# Script for everflow git flow

usage(){
    echo "$(tput setaf 2)This script used for easy work with advanced branching model"
    echo
    echo "$(tput setaf 2)Usage:"
    echo "$(tput setaf 2)  everflow $(tput setaf 3)<command>"
    echo
    echo "$(tput setaf 2)Available commands:"
    echo "$(tput setaf 3)  init   $(tput setaf 2)initialize everflow in git repository"
    echo "$(tput setaf 3)  send   $(tput setaf 2)sending changes to the server"
    echo "$(tput setaf 3)  update $(tput setaf 2)update master from server"
}

main(){
    SCRIPT_DIR=$(dirname $0)
    FILES_DIR="$SCRIPT_DIR/everflow-files"

    # If no command just show usage
    if [ $# -lt 1 ]; then
        usage
        exit 1
    fi

    . "$FILES_DIR/common"

}

main "$@"

