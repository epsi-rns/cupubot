#!/usr/bin/env bash

function process_newmember() {
	# global-project : last_id
	# global-module  : _
	local i update message_id chat_id

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

        local update_with_new_member=$(echo $update | jq -r ".message | select(.new_chat_member != null)")
        # echo "${update_with_new_member}"

        if [ -n "$update_with_new_member" ];
        then
            get_feedback_newmember "$update"
            
            # display on standard output
            echo -e "\n: ${feedback}"

            result=$(curl -s "${tele_url}/sendMessage" \
                      --data-urlencode "chat_id=${chat_id}" \
                      --data-urlencode "text=$return_feedback"
                );
            # echo $result | json_reformat
        fi

        last_id=$(($last_id + 1))            
        echo $last_id > $last_id_file
    done
}

function get_feedback_newmember() {
	# global-module  : return_feedback
    local update=$1

    local new_chat_member=$(echo $update | jq -r ".message.new_chat_member")
    # echo "$new_chat_member"
        
    local first_name=$(echo $new_chat_member | jq -r ".first_name")
    local last_name=$(echo $new_chat_member | jq -r ".last_name")
    local username=$(echo $new_chat_member | jq -r ".username")
        
    # "😊"
    return_feedback="Selamat datang di @dotfiles_id 😊, $first_name $last_name @${username}."
}

