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

### -- function -- 

function parse_update() {

    updates=$(curl -s "${tele_url}/getUpdates?offset=$last_id")
    # echo $updates | json_reformat

    count_update=$(echo $updates | jq -r ".result | length") 
    # echo $count_update
    
    [[ $count_update -eq 0 ]] && echo -n "."

    for ((i=0; i<$count_update; i++)); do
        update=$(echo $updates | jq -r ".result[$i]")
        # echo "$update"
    
        last_id=$(echo $update | jq -r ".update_id") 
        # echo "$last_id"
     
        message_id=$(echo $update | jq -r ".message.message_id") 
        # echo "$message_id"
    
        chat_id=$(echo $update | jq -r ".message.chat.id") 
        # echo "$chat_id"
        
        text=$(echo $update | jq -r ".message.text") 
        # echo "$text"
        
        get_feedback "$text"
    
        result=$(curl -s "${tele_url}/sendMessage" \
                  --data-urlencode "chat_id=${chat_id}" \
                  --data-urlencode "reply_to_message_id=${message_id}" \
                  --data-urlencode "text=$feedback"
            );
        # echo $result | json_reformat

        last_id=$(($last_id + 1))            
        echo $last_id > $last_id_file
        
        echo -e "\n: ${text}"
    done
}

function get_feedback() {
	first_word=$(echo $text | head -n 1 | awk '{print $1;}')
	# echo $first_word
	
	feedback='Good message !'
	case $first_word in
        '/id') 
            username=$(echo $update | jq -r ".message.chat.username")
            feedback="You are the mighty @${username}"
        ;;
        *)
            feedback='Thank you for your message.'            
        ;;
    esac
}

### -- main -- 

while true; do 
    parse_update    
    sleep 1
done
