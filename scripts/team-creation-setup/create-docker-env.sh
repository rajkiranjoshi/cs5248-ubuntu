#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 <team-name> <port to map ssh to> <port to map http to>"
    exit 1
fi

if [ $# -ne 3 ];then
    echo "Please pass the team name, ssh port mapping, http port mapping, as an argument"
    echo "The port numbers could be any above 32700"
    exit 1
fi

team=$1
ssh_port=$2
http_port=$3

id -u $team > /dev/null 2>&1
does_not_exist=$?

if [ $does_not_exist -eq 1 ];then
    echo "The user $team does not exist!!"
    echo "Please create the use first and then try again"
    exit 1
fi


echo "################"
echo "###  Step 1  ###"
echo "################"
echo "*** Creating SSH key for $team ***"
if [ -f /home/$team/.ssh/id_rsa.pub ];then
    echo "Public key already exists. Moving on ..."
else
    runuser -l $team -c 'mkdir .ssh' # to prevent the next command from failing
    runuser -l $team -c 'ssh-keygen -q -f .ssh/id_rsa -N ""'
fi

echo "################"
echo "###  Step 2  ###"
echo "################"
echo "*** Creating a Docker shared folder ***"
runuser -l $team -c 'mkdir -p docker-shared'

echo "################"
echo "###  Step 3  ###"
echo "################"
echo "*** Starting up the Docker environment  ***"

docker run -d -p $ssh_port:22 -p $http_port:80 --name $team -e USERNAME=$team -e ROOT_PUB_KEY="$(cat /home/$SUDO_USER/.ssh/id_rsa.pub)" -e USER_PUB_KEY="$(cat /home/$team/.ssh/id_rsa.pub)" -v /home/$team/docker-shared:/home/$team/docker-shared rajjoshi/cs5248-ubuntu


ssh_mapping=$(docker ps | grep $team | tr -s ' ' | rev | cut -d ' ' -f 3 | rev); echo ${s::-1}
ssh_mapping=${ssh_mapping::-1} # to remove the last comma
http_mapping=$(docker ps | grep $team | tr -s ' ' | rev | cut -d ' ' -f 2 | rev); echo ${s::-1}

echo "#################################"
echo "###  Port Mappings for $team ###"
echo "#################################"
echo "For ssh: $ssh_mapping"
echo "For http: $http_mapping"

# Workaround for docker-shared folder's ownership problem
sleep 2
sudo chown -R $team:$team /home/$team/docker-shared

echo "Done!"
