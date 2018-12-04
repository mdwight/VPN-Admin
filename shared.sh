#!/bin/bash
# VPN-Admin -- A script base system for managing a small OpenVPN system
#
# Copyright (C) 2018 by Matthew Dwight.
#
# This code released under version 3 of the GNU GPL; see COPYING.md and the
# LICENSE.md for this project for full licensing details.

# Shared functions used by the main script. Not to be run directly.

function easyrsa_check {
    if [ ! -f "$SETUP_DIR/easyrsa3/easyrsa" ] ; then
        printf "Error: EasyRSA3 not installed.\n"
        exit 1
    fi
}

function ca_check {
    # see if system has been initialized and the CA created.
    if [ ! -f "$SETUP_DIR/easyrsa3/pki/ca.crt" ] ; then
        printf "ERROR: The system has not been initialized. \n"
        exit 10
    fi
}

function sudo_check {
    # make sure user had sudo access
    sudo printf ""
    if [ $? -ne 0 ] ; then
        exit 1
    fi
}

function verify {
    while true ; do
        if [ $# -gt 0 ] ; then
            printf "$1"
        else
            printf "Verify 'YES' or 'NO' > "
        fi
        read USERINPUT
        if [[ -z "$USERINPUT" ]]; then
            continue
        fi

        if [ ${USERINPUT^^} == "YES" ] ; then
            return 0
	    fi
    	if [ ${USERINPUT^^} == "NO" ] ; then
            return 1
    	fi
    done
}
