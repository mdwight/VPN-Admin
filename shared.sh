#!/bin/bash
# VPN-Admin -- A script base system for managing a small OpenVPN system
#
# Copyright (C) 2018 by Matthew Dwight.
#
# This code released under version 3 of the GNU GPL; see COPYING.md and the
# LICENSE.md for this project for full licensing details.

# Shared functions used by the main script. Not to be run directly.


function parameter_type {
# checks config or parameter files to see if the parameter are for a client or server. 
# returns 1 for server, 2 for client, 3 for unknown and 4 file not found.
# take a parameter of a file name to check.

    if [ ! -f $1 ] ; then   # file not found 
        return 4
    fi

    if  grep -q 'remote-cert-tls client' $1 ; then  # parameter found in server config only
        return 1
    elif grep -q 'remote-cert-tls server' $1 ; then # parameter found in client config only
        return 2
    else                                            # can't find parameter. Type is unknown.
        return 3
    fi
}

function certificate_type {
# checks certificate file to see if the parameter are for a client or server. 
# returns 1 for server, 2 for client, 3 for unknown and 4 file not found.
# take a parameter of a file name to check.

    if [ ! -f $1 ] ; then   # file not found 
        return 4
    fi
    if grep -q 'TLS Web Server Authentication' $1 ; then   # found only in server certificate only
        return 1
    elif grep -q 'TLS Web Client Authentication' $1 ; then # found only in client certificate only
        return 2
    else                                                   # can't find parameter. Type is unknown.
        return 3
    fi
}


function easyrsa_check {
# see if the OpenVPN/easyrsa system has been installed.
    if [ ! -f "$SETUP_DIR/easyrsa3/easyrsa" ] ; then
        printf "Error: EasyRSA3 not installed.\n"
        exit 1
    fi
}

function ca_check {
# See if system has been initialized and the CA created.
    if [ ! -f "$SETUP_DIR/easyrsa3/pki/ca.crt" ] ; then
        printf "ERROR: The system has not been initialized. \n"
        exit 10
    fi
}

function sudo_check {
# Make sure user had sudo access before running commands requiring root elevation.
    sudo printf ""
    if [ $? -ne 0 ] ; then
        exit 1
    fi
}

function verify {
# prompt for verification. return 0 for Yes and and 1 for No.
# verify that a string paramater for the prompt. If not provide gives default.
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
