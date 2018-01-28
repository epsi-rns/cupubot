#!/usr/bin/env bash

function process_logger_html() {
	# global-project : last_id
	# global-module  : _
	local i update message avatar_image

	# Do not offset ! Stay with ID.
	# Script might need to be restarted.
    # updates=$(curl -s "${tele_url}/getUpdates?offset=$last_id")
    
    local updates=$(curl -s "${tele_url}/getUpdates")
    # echo $updates | json_reformat

    local count_update=$(echo $updates | jq -r ".result | length") 
    # echo $count_update
    
    [[ $count_update -eq 0 ]] && echo -n "."

    for ((i=0; i<$count_update; i++)); do
        update=$(echo $updates | jq -r ".result[$i]")
        # echo "$update"
        
        message=$(echo $update | jq -r ".message") 
        # echo "$message"
    
        last_id=$(echo $update | jq -r ".update_id") 
        # echo "$last_id" 

        get_avatar "$message"
        get_log_html_line "$message"
        
        # display on standard output
        echo -e "${return_log_line_text}"

        avatar_image="<img src='${return_avatar_url}' height='42' width='42'"
        avatar_image+=" style=' vertical-align: text-top;'>"
        
cat << EOF >> $log_file_html
    <tr>
      <td valign="top">
        ${avatar_image}
      </td>
      <td valign="top">
        ${return_log_line_html}
      </td>
    </tr>
EOF

        last_id=$(($last_id + 1))            
        # echo $last_id > $last_id_file
    done
}

function get_log_html_line() {
	# global-module  : return_log_line_text return_log_line_html
    local message=$1
    
    local from=$(echo $update | jq -r ".message.from") 
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
       text=":: ~ ${reply_first_name} : ${reply_text}<br/>${text}"
    fi

    return_log_line_text="[ $textdate ] @${username} ~ $first_name $last_name:\n$text\n\n"

    text=$(echo "${text//$'\n'/<br/>}")    
    return_log_line_html="[ $textdate ] @${username} ~ $first_name $last_name:<br/>$text<br/>"
}

function get_avatar() {
	# global-module  : return_avatar_url
    local message=$1   

    local chat_id=$(echo $message | jq -r ".chat.id") 
    # echo "$chat_id"
    
    local from=$(echo $update | jq -r ".message.from") 
    # echo "$from"

    local from_id=$(echo $from | jq -r ".id")
    local photos=$(curl -s "${tele_url}/getUserProfilePhotos?user_id=$from_id&limit=1")
    #echo $photos | json_reformat
    local photo=$(echo $photos | jq -r ".result.photos[0][0]")   
    local file_id_photo=$(echo $photo | jq -r ".file_id")
    
    local get_file=$(curl -s "${tele_url}/getFile?file_id=$file_id_photo")
    # echo $get_file | json_reformat
    
    local file_path=$(echo $get_file | jq -r ".result.file_path")   
    local file_id=$(echo $get_file | jq -r ".result.file_id")   
    # echo $file_path
    
    return_avatar_url="https://api.telegram.org/file/bot${token}/$file_path?file_id=$file_id"
    
    # https://api.telegram.org/file/bot<token>/
}
