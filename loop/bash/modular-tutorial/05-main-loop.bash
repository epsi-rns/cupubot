#!/usr/bin/env bash

### -- module --

DIR=$(dirname "$0")
. ${DIR}/05-config.bash
. ${DIR}/05-controller.bash
. ${DIR}/03-task-observe.bash   # no need
. ${DIR}/05-task-reply.bash

### -- main --

loop_reply

