#!/usr/bin/env bash

function process_reply() {
	local i update message_id chat_id
    local updates=$(curl -s "${tele_url}/getUpdates")
    local count_update=$(echo $updates | jq -r ".result | length") 
    
    for ((i=0; i<$count_update; i++)); do
        update=$(echo $updates | jq -r ".result[$i]")
    
        message_id=$(echo $update | jq -r ".message.message_id")     
        chat_id=$(echo $update | jq -r ".message.chat.id") 
           
        result=$(curl -s "${tele_url}/sendMessage" \
                  --data-urlencode "chat_id=${chat_id}" \
                  --data-urlencode "reply_to_message_id=${message_id}" \
                  --data-urlencode "text=Thank you for your message."
            );
    done
}
