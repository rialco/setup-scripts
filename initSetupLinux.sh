#!/bin/bash

echo 'Beginning setup for new debian-based machine'

# Update base packages
printf "Updating system..."
apt update -qq
apt upgrade -qq
apt autoremove -y
printf "Finished update \n\n"

# Install essentials
printf "Installing essentials... (vim, wget, gpg) \n\n"
apt install vim wget gpg -qq
printf "\n\n"

# Install docker 

echo "Do you want to install Docker?"

select yn in "Yes" "No";
do
	case $yn in
	Yes)
	printf "Installing docker";
	apt-get remove docker docker-engine docker.io containerd runc -y;
	apt-get install ca-cert curl gnupg lsb-release -y;

	curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;

	echo \
  	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  	$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null;

	apt-get update -qq;
	apt-get install docker-ce docker-ce-cli containerd.io -qq;
	break;;
	No)
	break;;
	esac;
done;
