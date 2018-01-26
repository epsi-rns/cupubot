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

        get_avatar   "$message"
        get_log_line "$message"
        echo -e "${log_line_text}"
        
        echo "<tr>"  >> $log_file
        
        echo "    <td>"      >> $log_file
        echo "<img src='${avatar_url}' height='42' width='42' style=' vertical-align: text-top;'>" >> $log_file
        echo "    </td>"     >> $log_file
        
        echo "    <td>"      >> $log_file
        echo "${log_line_html}"   >> $log_file
        echo "    </td>"     >> $log_file
        
        echo "</tr>"  >> $log_file

        last_id=$(($last_id + 1))            
        # echo $last_id > $last_id_file
    done
}

function get_log_line() {
    local message=$1   
    
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
       text=":: ~ ${reply_first_name} : ${reply_text}<br/>${text}"
    fi

    log_line_text="[ $textdate ] @${username} ~ $first_name $last_name:\n$text\n\n"
    log_line_html="[ $textdate ] @${username} ~ $first_name $last_name:<br/>$text<br/>"
}

function get_avatar() {
    local message=$1   


    chat_id=$(echo $message | jq -r ".chat.id") 
    # echo "$chat_id"
    
    from=$(echo $update | jq -r ".message.from") 
    # echo "$from"

    from_id=$(echo $from | jq -r ".id")
    photos=$(curl -s "${tele_url}/getUserProfilePhotos?user_id=$from_id&limit=1")
    #echo $photos | json_reformat
    photo=$(echo $photos | jq -r ".result.photos[0][0]")   
    file_id=$(echo $photo | jq -r ".file_id")
    
    get_file=$(curl -s "${tele_url}/getFile?file_id=$file_id")
    # echo $get_file | json_reformat
    
    file_path=$(echo $get_file | jq -r ".result.file_path")   
    file_id=$(echo $get_file | jq -r ".result.file_id")   
    # echo $file_path
    
    avatar_url="https://api.telegram.org/file/bot${token}/$file_path?file_id=$file_id"
    
    # https://api.telegram.org/file/bot<token>/
}
