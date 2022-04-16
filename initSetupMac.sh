#!/bin/bash
printf "==> Beginning setup for a new Mac \n\n"

BLUE='\033[0;34m';
NC='\033[0m';

printf "==> Installing homebrew \n\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | tee ~/.zprofile

echo -e "${BLUE}==> Installing essentials (wget, firefox, visual studio code, zsh syntax highlight & auto-suggestions)${NC}"

brew install wget
if [ ! -d "/Applications/Firefox.app" ]; then
	brew install --cask firefox;
else
	echo "Firefox is already installed";
fi
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
	brew install --cask visual-studio-code;
else
	echo "Visual studio code is already installed";
fi

echo -e "${BLUE}==> Do you want to install NVM & add it to PATH?${NC}"

select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		echo "Installing NVM...";
		wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
		echo "Adding nvm command to PATH";
		echo 'export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc; 
		break;;
		No) 
		break;;
    esac
done

echo -e "${BLUE}==> Do you want to install docker?${NC}"

select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		echo "Dowloading docker.dmg"
		wget https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-arm64;
		echo "Mounting docker.dmg"
		sudo hdiutil attach Docker.dmg;
		echo "Beginning docker installation"
		sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license;
		echo "Unmounting docker.dmg"
		sudo hdiutil detach /Volumes/Docker;
		break;;
		No) 
		break;;
    esac
done

echo -e "${BLUE}==> Do you want to install PostgreSQL?${NC}"

select yn in "Yes" "No"; 
do
    case $yn in
        Yes)
		brew install postgresql
		break;;
		No) 
		break;;
    esac
done
