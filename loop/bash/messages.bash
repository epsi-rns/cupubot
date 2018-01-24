#!/usr/bin/env bash

function message_usage() {
    cat <<-EOF
usage:  cupubot [options]
operations:
 general
   -v, --version    display version information
   -h, --help       display help information

EOF
}

function message_version() {
	local version='v0.001'
    echo "cupubot $version"
}

# vim:set ts=4 sw=2 et:
