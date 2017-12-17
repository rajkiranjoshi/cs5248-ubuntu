#!/bin/bash

if [ $# -ne 1 ];then
    echo "Please provide the team username as an argument"
    exit 1
fi


team=$1
echo "Blocking account for $team"
read -p "Press enter to continue ..."

sudo chage -E 0 $team  # blocks any future logins

# logs out current session

sessions=($(who | grep $team | cut -d' ' -f4))

echo $sessions

for session in "${sessions[@]}";do
    process="$(ps -dN | grep $session | cut -d' ' -f1)"
    echo "Killing process $process for bash session $session"
    read -p "Press enter to continue ..."
    sudo kill -9 $process
done



echo "Done!"
