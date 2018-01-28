#!/usr/bin/env bash

function message_usage() {
    cat <<-EOF
usage:  cupubot [options]

operations:
 general
   -v, --version    display version information
   -h, --help       display help information
   --observe        show JSON output of getUpdates
   --reply          reply all messages
   --new-member     greet new member
   --logger-text    log chat conversation
   --logger-html    log chat conversation
EOF
}

function message_version() {
	local version='v0.001'
    echo "cupubot $version"
}
