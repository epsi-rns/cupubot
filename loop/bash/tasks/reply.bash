#!/usr/bin/env bash

function process_reply() {
	# global-project : last_id
	# global-module  : _
	local i update message_id chat_id text

    local updates=$(curl -s "${tele_url}/getUpdates?offset=$last_id")
    # echo $updates | json_reformat

    local count_update=$(echo $updates | jq -r ".result | length") 
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
        
        get_feedback_reply "$update"
    
        result=$(curl -s "${tele_url}/sendMessage" \
                  --data-urlencode "chat_id=${chat_id}" \
                  --data-urlencode "reply_to_message_id=${message_id}" \
                  --data-urlencode "text=$return_feedback"
            );
        # echo $result | json_reformat

        last_id=$(($last_id + 1))            
        echo $last_id > $last_id_file
        
        echo -e "\n: ${text}"
    done
}

function get_feedback_reply() {
	# global-module  : return_feedback
    local update=$1
    
    text=$(echo $update | jq -r ".message.text") 
    # echo "$text"
	
	local first_word=$(echo $text | head -n 1 | awk '{print $1;}')
	# echo $first_word
	
	return_feedback='Good message !'
	case $first_word in
        '/id') 
            username=$(echo $update | jq -r ".message.chat.username")
            return_feedback="You are the mighty @${username}"
        ;;
        *)
            return_feedback='Thank you for your message.'            
        ;;
    esac
}
