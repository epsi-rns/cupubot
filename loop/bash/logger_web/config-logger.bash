#!/usr/bin/env bash
# no need sha-bang for the script to run,
# but needed, so file manager can detect its type.

### -- config -- 

# $token variable here in config.sh
config_file=~/.config/cupubot/config.sh

if [ ! -f $config_file ];
then
    echo "Config not found!" && exit 0
else
    source $config_file
fi

tele_url="https://api.telegram.org/bot${token}"

### -- last update --
last_id_file=~/.config/cupubot/id.txt
last_id=0

if [ ! -f $last_id_file ];
then
    touch $last_id_file
    echo 0 > $last_id_file    
else
    last_id=$(cat $last_id_file)
    # echo "last id = $last_id"
fi

### -- logfile --
log_file=./logfile.html

rm $log_file

if [ ! -f $log_file ];
then
    touch $log_file
fi
