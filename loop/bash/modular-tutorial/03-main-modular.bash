#!/usr/bin/env bash
# This is a telegram bot in bash

# Copyright: E. Rizqi N. Sayidina <epsi.nurwijayadi@gmail.com>
# License:   The MIT License (MIT)

### -- module --

DIR=$(dirname "$0")
. ${DIR}/03-config.bash
. ${DIR}/03-controller.bash
. ${DIR}/03-task-observe.bash

### -- main --

do_observe

