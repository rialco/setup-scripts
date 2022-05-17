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

echo -e "${BLUE}==> Do you want to set zsh as the default shell?${NC}"
select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		chsh -s /usr/bin/zsh
		break;;
		No) 
		break;;
    esac
done

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
		echo 'export EDITOR="code -w"' >> ~/.zshrc;
		break;;
		No) 
		break;;
    esac
done

echo -e "${BLUE}==> Do you want to install Visual Studio Code?${NC}"
select yn in "Yes" "No";
do
	case $yn in
	Yes)
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg

	apt install apt-transport-https
	apt update
	apt install code # or code-insiders
	break;;
	No)
	break;;
	esac;
done;

echo -e "${BLUE}==> Do you want to install Docker?${NC}"
select yn in "Yes" "No";
do
	case $yn in
	Yes)
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
