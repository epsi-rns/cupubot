# reading
# http://wiki.bash-hackers.org/howto/getopts_tutorial

# handling command
function handle_command_plain() {
	local command=$1

    case "$command" in
        version)   
            message_version
            exit;;
    esac
}

# handling -command
function handle_command_opt() {
	local command=$1
	
    case "$command" in
        -)
            handle_command_optarg "$OPTARG"
            ;;
         h)  
            message_usage
            exit;;
         v)  
            message_version
            exit;;
         *)  
            # Invalid Option
            message_usage
            exit;;
    esac
}

# handling --command
function handle_command_optarg() {
	local command=$1
	
    case "$command" in
        version) 
            message_version
            exit;;
        help) 
            message_usage
            exit;;
        observe)
            do_observe
            exit;;
        reply)
            loop_reply
            exit;;
        new-member)
            loop_newmember
            exit;;
        logger-text)
            do_logger_text
            exit;;
        logger-html)
            do_logger_html
            exit;;
        *) 
            # Invalid Option
            message_usage
            exit;;
    esac
}

function get_options_from_arguments() {  
	# get argument length	
	[[ $# -eq "0" ]] && message_usage && exit;
	 
    # ! : indirect expansion
    while [[ -n "${!OPTIND}" ]]; do
        handle_command_plain "${!OPTIND}"

        while getopts "vh-:" OPT; do
             handle_command_opt "$OPT"
        done

        shift $OPTIND
        OPTIND=1
    done
    
	# Invalid Option
    message_usage
    exit
}
