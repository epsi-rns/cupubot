#!/usr/bin/env bash
# This is a telegram bot in bash

# Copyright: E. Rizqi N. Sayidina <epsi.nurwijayadi@gmail.com>
# License:   The MIT License (MIT)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# module: main
. ${DIR}/config.bash
. ${DIR}/messages.bash
. ${DIR}/options.bash
. ${DIR}/controller.bash

# module: task
. ${DIR}/tasks/observe.bash
. ${DIR}/tasks/reply.bash
. ${DIR}/tasks/new_member.bash
. ${DIR}/tasks/logger_text.bash
. ${DIR}/tasks/logger_html.bash

### -- main --

get_options_from_arguments "$@"

