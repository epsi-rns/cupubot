#!/usr/bin/env bash

# This is a telegram bot in bash

# Copyright: E. Rizqi N. Sayidina <epsi.nurwijayadi@gmail.com>
# License:   The MIT License (MIT)

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

### -- main -- 

updates=$(curl -s "${tele_url}/getUpdates")
count_update=$(echo $updates | jq -r ".result | length") 
    
for ((i=0; i<$count_update; i++)); do
    update=$(echo $updates | jq -r ".result[$i]")
        
    last_id=$(echo $update | jq -r ".update_id")      
    message_id=$(echo $update | jq -r ".message.message_id")     
    chat_id=$(echo $update | jq -r ".message.chat.id") 
           
    result=$(curl -s "${tele_url}/sendMessage" \
                  --data-urlencode "chat_id=${chat_id}" \
                  --data-urlencode "reply_to_message_id=${message_id}" \
                  --data-urlencode "text=Thank you for your message."
        );
done
