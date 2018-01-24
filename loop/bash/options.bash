#!/usr/bin/env bash
# no need sha-bang for the script to run,
# but needed, so file manager can detect its type.

function get_options_from_arguments() {

    # http://wiki.bash-hackers.org/howto/getopts_tutorial

    # get options
    count=0
    
    # ! : indirect expansion
    while [[ -n "${!OPTIND}" ]]; do
        case "${!OPTIND}" in
            version)   
                message_version; 
                exit;;
        esac

        while getopts "vh-:" OPT; do
            case "$OPT" in
                -)
                    case "$OPTARG" in
                        version) 
                            message_version; 
                            exit;;
                        help) 
                            message_usage; 
                            exit;;
                        *) 
                            continue;;
                    esac;;
                h)  
                    message_usage; 
                    exit;;
                v)  
                    message_version; 
                    exit;;
                *)  
                    continue;;
            esac
        done

        shift $OPTIND
        OPTIND=1
    done
}
