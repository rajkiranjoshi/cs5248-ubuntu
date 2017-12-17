#!/bin/bash

if [ $# -ne 1 ];then
    echo "Please provide the team username as an argument"
    exit 1
fi


team=$1
echo "Unblocking account for $team"
read -p "Press enter to continue ..."

sudo chage -E -1 $team

echo "Done!"
