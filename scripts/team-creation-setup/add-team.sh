#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 <team-name>"
    exit 1
fi


if [ $# -ne 1 ];then
	echo "Specify the team name as an argument"
    exit 1
fi

team=$1

adduser $team
runuser -l $team -c 'mkdir -p public_html'

chage -d 0 $team       # to force passwd change on first login


gpasswd -a www-data $team   # add www-data to the user's grp to be able to access public_html
service apache2 restart   # restart apache2 for www-data to get access to its new group

