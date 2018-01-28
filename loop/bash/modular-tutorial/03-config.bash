#!/usr/bin/env bash
# no need sha-bang for the script to run,
# but needed, so file manager can detect its type.

### -- config -- 

# $token variable here in config.sh
config_file=~/.config/cupubot/config.sh

if [ ! -f $config_file ];
then
    ## exit success (0)
    echo "Config not found!" && exit 0 
else
    source $config_file
fi

tele_url="https://api.telegram.org/bot${token}"
