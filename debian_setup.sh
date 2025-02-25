#!/bin/bash
printf "==> Beginning setup for new debian-based machine \n\n"

BLUE='\033[0;34m';
NC='\033[0m';

# Update base packages
printf "Updating system..."
sudo apt update -qq
sudo apt upgrade -qq
sudo apt autoremove -y
printf "Finished update \n\n"

# Install essentials
echo -e "${BLUE}==> Installing essentials (vim, wget, gpg, zsh)${NC}"

sudo apt install vim wget gpg gcc make unzip zsh -qq
printf "\n\n"

echo "==> Setting ZSH as the default shell";
sudo chsh -s /usr/bin/zsh
echo "ZSH is now the default shell";

printf "\n\n"

echo -e "${BLUE}==> Do you want to install Oh my zsh, zsh syntax highlight & auto-suggestions?${NC}"
select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
		echo "Finished installing Oh my zsh";
		echo "==> Installing PowerLevel10k";
		sudo rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;
		echo "Powerlevel10k finished installing";
		echo "==> Installing Syntax Highlighting";
		sudo rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
		echo "Sytanx highlighting finished installing";
		echo "==> Installing auto-suggestions";
		sudo rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
		echo "Auto-suggestions finished installing"
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

echo -e "${BLUE}==> Do you want to install node and the nvm?${NC}"
select yn in "Yes" "No"; 
do
  case $yn in
    Yes)
      wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
      export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
      nvm install --lts
      break;;
		No) 
		  break;;
  esac
done

echo -e "${BLUE}==> Do you want to create a ssh key for github?${NC}"
select yn in "Yes" "No"; 
do
  case $yn in
    Yes)
		  ssh-keygen -t ed25519 -C "your_email@example.com"
      ssh-add ~/.ssh/id_ed25519
      cat ~/.ssh/id_ed25519.pub
      break;;
		No) 
		  break;;
  esac
done

echo -e "${BLUE}==> Do you want to install NVIM?${NC}"
select yn in "Yes" "No"; 
do
  case $yn in
    Yes)
		  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
      sudo rm -rf /opt/nvim
      sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

      echo PATH="$PATH:/opt/nvim-linux-x86_64/bin" | tee -a ~/.zshrc
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
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	  sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    break;;
	No)
	break;;
	esac;
done;
