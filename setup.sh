#!/bin/bash

if [ -z "$USERNAME" ];then
	echo "=> Please pass the username in an env variable 'username'"
	exit 1
fi

if [ -z "$ROOT_PUB_KEY" ];then
	echo "=> Please pass the public key for root user"
	exit 1
fi

if [ -z "$USER_PUB_KEY" ];then
	echo "=> Please pass the public key for the regular user"
	exit 1
fi

echo "=> Adding user '$USERNAME' with sudo priviledges"
adduser --disabled-password --gecos "" $USERNAME
# Docker's mount volume option already creates the user dir
# In this case, adduser won't copy the skeleton
# So do it manually!
cp -r /etc/skel/. /home/$USERNAME/
chown -R $USERNAME:$USERNAME /home/$USERNAME/ # need to change owner as well
addgroup $USERNAME sudo # add user to sudoers
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers # nullify the need for sudo password
echo "=> Done!"

echo "=> Installing public key for root user"
mkdir -p /root/.ssh
chmod go-rwx /root/.ssh
echo "$ROOT_PUB_KEY" > /root/.ssh/authorized_keys
chmod go-rw /root/.ssh/authorized_keys
echo "=> Done!"

echo "=> Installing public key for the regular user"
mkdir -p /home/$USERNAME/.ssh
chmod go-rwx /home/$USERNAME/.ssh
echo "$USER_PUB_KEY" > /home/$USERNAME/.ssh/authorized_keys
chmod go-rw /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
echo "=> Done!"

# Fix the perl locale warning
for home in /root /home/$USERNAME; do
	echo "export LANGUAGE=en_US.UTF-8" >> $home/.bashrc
	echo "export LANG=en_US.UTF-8" >> $home/.bashrc
	echo "export LC_ALL=en_US.UTF-8" >> $home/.bashrc
done