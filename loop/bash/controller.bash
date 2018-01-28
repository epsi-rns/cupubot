#!/usr/bin/env bash

### -- task controller --

function do_observe() {
    process_observe
} 

function loop_reply() {
    while true; do 
        process_reply   
        sleep 1
    done
}

function loop_newmember() {
    while true; do 
        process_newmember   
        sleep 1
    done
}

function do_logger_text() {
	# empty logger file
	[[ -f $log_file_text ]] && rm $log_file_text
	
    process_logger_text
} 

function do_logger_html() {
	
	# empty logger file
	[[ -f $log_file_html ]] && rm $log_file_html
	
cat << EOF >> $log_file_html
<html>
<head>
  <title>Log</title>
  <meta charset="utf-8">
</head>
<body>
  <table>
EOF

process_logger_html

cat << EOF >> $log_file_html
  </table>
</body>
</html>
EOF


} 
