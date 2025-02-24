#!/bin/bash
printf "==> Beginning setup for new debian-based machine \n\n"

BLUE='\033[0;34m';
NC='\033[0m';

# Update base packages
printf "Updating system..."
apt update -qq
apt upgrade -qq
apt autoremove -y
printf "Finished update \n\n"

# Install essentials
echo -e "${BLUE}==> Installing essentials (vim, wget, gpg, zsh)${NC}"

apt install vim wget gpg zsh -qq
printf "\n\n"

echo "==> Setting ZSH as the default shell";
chsh -s /usr/bin/zsh
echo "ZSH set as the default shell successfully ";

printf "\n\n"

echo -e "${BLUE}==> Do you want to install Oh my zsh, zsh syntax highlight & auto-suggestions?${NC}"
select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
		echo "Finished installing Oh my zsh";
		echo "==> Installing PowerLevel10k";
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;
		echo "Powerlevel10k finished installing";
		echo "==> Installing Syntax Highlighting";
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
		echo "Sytanx highlighting finished installing";
		echo "==> Installing auto-suggestions";
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
		echo "Auto-suggestions finished installing";

		echo "==> Starting P10K config";
		p10k configure;

		echo "==> Editing .zshrc file to include recently downloaded changes";
		sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc;
		sed 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/' ~/.zshrc;
		sed 's/# ENABLE_CORRECTION="true"/ENABLE_CORRECTION="true"/' ~/.zshrc;
		break;;
		No) 
		break;;
    esac
done

echo -e "${BLUE}==> Do you want to install Docker?${NC}"
select yn in "Yes" "No";
do
	case $yn in
	Yes)
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	  chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    break;;
	No)
	break;;
	esac;
done;
