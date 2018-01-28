#!/usr/bin/env bash

function process_logger_text() {
	# global-project : last_id
	# global-module  : _
	local i update message

	# Do not offset ! Stay with ID.
	# Script might need to be restarted.
    # updates=$(curl -s "${tele_url}/getUpdates?offset=$last_id")
    
    local updates=$(curl -s "${tele_url}/getUpdates")
    # echo $updates | json_reformat

    local count_update=$(echo $updates | jq -r ".result | length") 
    # echo $count_update

    for ((i=0; i<$count_update; i++)); do
        update=$(echo $updates | jq -r ".result[$i]")
        # echo "$update"
        
        message=$(echo $update | jq -r ".message") 
        # echo "$message"
    
        last_id=$(echo $update | jq -r ".update_id") 
        # echo "$last_id" 
        
        get_log_text_line "$message"
        echo -e "${return_log_line_text}" | tee -a $log_file_text

        last_id=$(($last_id + 1))            
        # echo $last_id > $last_id_file
    done
}

function get_log_text_line() {
	# global-module  : return_log_line_text
    local message=$1

    local chat_id=$(echo $message | jq -r ".chat.id") 
    # echo "$chat_id"
    
    local from=$(echo $message | jq -r ".from") 
    # echo "$from"

    local first_name=$(echo $from | jq -r ".first_name")
    local last_name=$(echo $from | jq -r ".last_name")
    local username=$(echo $from | jq -r ".username")

    local unixdate=$(echo $message | jq -r ".date") 
    local textdate=$(date -d @$unixdate +'%H:%M:%S')

    local text=$(echo $message | jq -r ".text") 
    
    local message_is_reply=$(echo $message | jq -r "select(.reply_to_message != null)")
    
    if [ -n "$message_is_reply" ];
    then
       local reply=$(echo $message | jq -r ".reply_to_message") 
       local reply_text=$(echo $reply | jq -r ".text")
       local reply_first_name=$(echo $reply | jq -r ".from.first_name")
       text=":: ~ ${reply_first_name} : ${reply_text}\n\n${text}"
    fi

    return_log_line_text="[ $textdate ] @${username} ~ $first_name $last_name:\n$text\n\n"
}
