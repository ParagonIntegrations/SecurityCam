#!/bin/bash

CURRENTUSERNAME=pi

echo "Sudo User: $CURRENTUSERNAME"
#read -p "Type in the username you would like to use" CURRENTUSERNAME

SUDO=
if [ "$UID" != "0" ]; then
	if [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo '*** This quick installer script requires root privileges.'
		exit 0
	fi
fi

$SUDO apt update
$SUDO apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     git

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | $SUDO apt-key add -

echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) stable" | \
    $SUDO tee /etc/apt/sources.list.d/docker.list

$SUDO apt update

$SUDO apt install -y --no-install-recommends \
    docker-ce \
    cgroupfs-mount

$SUDO systemctl enable docker
$SUDO systemctl start docker

$SUDO apt install -y python3-pip libffi-dev

$SUDO pip3 install docker-compose

$SUDO usermod -a -G docker $CURRENTUSERNAME
$SUDO exec sg docker newgrp `id -gn`

cd /home/$CURRENTUSERNAME
git clone https://github.com/ParagonIntegrations/SecurityCam.git

cd /home/$CURRENTUSERNAME/SecurityCam/volumes/homeassistant
#tar -xzvf storage.tar.gz
#$SUDO rm /home/pi/axpert_homeassistant/volumes/homeassistant/.storage/core.restore_state

cd /home/$CURRENTUSERNAME/SecurityCam
$SUDO git checkout develop
# docker-compose up -d