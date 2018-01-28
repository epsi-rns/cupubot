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
