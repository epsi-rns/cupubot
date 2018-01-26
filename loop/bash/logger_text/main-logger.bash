#!/usr/bin/env bash
# sha-bang required

# This is a telegram bot in bash

# Copyright: E. Rizqi N. Sayidina <epsi.nurwijayadi@gmail.com>
# License:   The MIT License (MIT)


# Can't use DIR=$(dirname "$0"), because of redirection
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/config-logger.bash
. ${DIR}/functions-logger.bash

### -- main -- 

parse_update 

# while true; do 
#    parse_update    
#    sleep 1
# done