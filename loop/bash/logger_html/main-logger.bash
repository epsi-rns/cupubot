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

echo "<html>"  >> $log_file
echo "<head>"  >> $log_file
echo "    <title>Log</title>"  >> $log_file
echo '    <meta charset="utf-8">'  >> $log_file
echo '    <link rel="stylesheet" href="log.css">'  >> $log_file
echo "</head>"  >> $log_file

echo "<body>"  >> $log_file

echo "<table>"  >> $log_file
parse_update 
echo "</table>"  >> $log_file

echo "</body>"  >> $log_file
echo "</html>"  >> $log_file
