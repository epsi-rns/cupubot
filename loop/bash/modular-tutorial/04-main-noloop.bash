#!/usr/bin/env bash

### -- module --

DIR=$(dirname "$0")
. ${DIR}/03-config.bash         # no change
. ${DIR}/04-controller.bash
. ${DIR}/03-task-observe.bash   # no need
. ${DIR}/04-task-reply.bash

### -- main --

do_reply

