#!/usr/bin/env bash
# no need sha-bang for the script to run,
# but needed, so file manager can detect its type.

### -- function -- 

function parse_update() {

	# Do not offset ! Stay with ID.
	# Script might need to be restarted.
    # updates=$(curl -s "${tele_url}/getUpdates?offset=$last_id")
    updates=$(curl -s "${tele_url}/getUpdates")

    # echo $updates | json_reformat

    count_update=$(echo $updates | jq -r ".result | length") 
    # echo $count_update
    
    [[ $count_update -eq 0 ]] && echo -n "."

    for ((i=0; i<$count_update; i++)); do
        update=$(echo $updates | jq -r ".result[$i]")
        # echo "$update"
        
        message=$(echo $update | jq -r ".message") 
        # echo "$message"
    
        last_id=$(echo $update | jq -r ".update_id") 
        # echo "$last_id" 
        
        get_log_line "$message"
        echo -e "${log_line}" # or using tee
        echo -e "${log_line}" >> $log_file

        last_id=$(($last_id + 1))            
        # echo $last_id > $last_id_file
    done
}

function get_log_line() {
    local message=$1   

    chat_id=$(echo $message | jq -r ".chat.id") 
    # echo "$chat_id"
    
    from=$(echo $update | jq -r ".message.from") 
    # echo "$from"

    first_name=$(echo $from | jq -r ".first_name")
    last_name=$(echo $from | jq -r ".last_name")
    username=$(echo $from | jq -r ".username")

    unixdate=$(echo $message | jq -r ".date") 
    textdate=$(date -d @$unixdate +'%H:%M:%S')

    text=$(echo $message | jq -r ".text") 
    
    message_is_reply=$(echo $message | jq -r "select(.reply_to_message != null)")
    
    if [ -n "$message_is_reply" ];
    then
       reply=$(echo $message | jq -r ".reply_to_message") 
       reply_text=$(echo $reply | jq -r ".text")
       reply_first_name=$(echo $reply | jq -r ".from.first_name")
       text=":: ~ ${reply_first_name} : ${reply_text}\n\n${text}"
    fi

    log_line="[ $textdate ] @${username} ~ $first_name $last_name:\n$text\n\n"
}
