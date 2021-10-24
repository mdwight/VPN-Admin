#!/bin/bash
# VPN-Admin -- A script base system for managing a small OpenVPN system
#
# Copyright (C) 2018 by Matthew Dwight.
#
# This code released under version 3 of the GNU GPL; see COPYING.md and the
# LICENSE.md for this project for full licensing details.

# Script to install or update VPN-Admin along with Open-VPN/easyrsa
#

# STEP 1 - Install/Update VPN-Admin into the current working directory.
# In case a previous download did not removed.
printf "Starting install/update of VPN-Admin.\n"
if [ -f ./v1.0.zip ] ; then
    rm v1.0.zip
fi
if [ -d ./VPN-Admin-1.0 ] ; then
    rm -fr ./VPN-Admin-1.0
fi

# Get easyrsa and copy to proper directory.
if wget https://github.com/mdwight/VPN-Admin/archive/refs/heads/v1.0.zip ; then
    unzip v1.0.zip
    cp -r ./VPN-Admin-1.0/* .
    rm -fr ./VPN-Admin-1.0
    rm v1.0.zip
    printf "Installation of VPN-Admin completed successfully.\n"
else
    printf "Error: Installation of VPN-Admin failed.\n"
    exit 1
fi

# STEP 2 - Install/Upgrade OpenVPN/easy-rsa
# Check to see that we are in the right directory and that VPN-Admin has been installed.
printf "Staring install/update of OpenVPN/easy-rsa.\n"
if [ ! -d ./parameters ] || [ ! -d ./ccd ] ; then
    printf "Error - VPN-Admin does appear to have been installed correctly.\n"
    exit 1
fi

# Create directory if new install
if [ ! -d ./easyrsa3 ] ; then
    mkdir easyrsa3
fi

# In case a previous download was not removed.
if [ -f ./v3.0.6.zip ] ; then
    rm v3.0.6.zip
fi
if [ -d ./easy-rsa-3.0.6 ] ; then
    rm -fr ./easy-rsa-3.0.6
fi

# Get easyrsa3 subdirectory and copy to ./easyrsa3 directory.
if wget https://github.com/OpenVPN/easy-rsa/archive/v3.0.6.zip ; then
    unzip v3.0.6.zip 'easy-rsa-3.0.6/easyrsa3/*'
    cp -r ./easy-rsa-3.0.6/easyrsa3/* ./easyrsa3
    rm -fr easy-rsa-3.0.6
    rm v3.0.6.zip
    printf "Installation of easyrsa3 completed successfully.\n"
    exit 0
else
    printf "Error: Installation of easyrsa3 failed.\n"
    exit 1
fi
