#!/bin/bash

# Run this script with sudo access available to install Miniconda3 to your machine

#Var Dump
installerPath="./Miniconda3-latest-Linux-x86_64.sh"
miniCondaPath="$HOME/miniconda3"
condaExe="$miniCondaPath/bin/conda" #This pathing is necessary for compatibility
pythonVer=3.13 #For modularities sake

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

#Preferences
#(Silent/quiet download flags are passed directly to curl below instead of a global preference, as nice as the progress bar is, it is tanking the download speed)

#Download helper - falls back to wget if curl isn't installed, and stops the script if the download actually fails #AI genned function
download() {
    local url="$1"
    local out="$2"
    if command -v curl &> /dev/null; then
        curl -s -L -f "$url" -o "$out"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$out"
    else
        echo -e "${RED}Error: neither curl nor wget is installed. Please install one (e.g. sudo apt install curl) and re-run this script${NC}"
        exit 1
    fi
    if [ $? -ne 0 ] || [ ! -s "$out" ]; then
        echo -e "${RED}Error: failed to download $url${NC}"
        exit 1
    fi
}

echo -e "${RED}Please ignore all terminal Pop-ups${NC}"

#Software Setup
    #VsCode
if command -v code &> /dev/null; then
    echo -e "${GREEN}VSCode is installed.${NC}"
else
    echo -e "${RED}VSCode isn't installed.${NC}"
    echo -e "${GREEN}Beginning Download...${NC}"
        #Install
    download "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" "./VSCodeUserSetup.tar.gz"
    echo -e "${GREEN}Installer download complete, beginning installation...${NC}"
    mkdir -p "$HOME/vscode"
    tar -xzf "./VSCodeUserSetup.tar.gz" -C "$HOME/vscode" --strip-components=1
    sudo ln -sf "$HOME/vscode/bin/code" /usr/local/bin/code #AI genned line
    echo -e "${GREEN}VSCode is installed.${NC}"
fi
echo -e "${GREEN}VSCode connection established, proceeding${NC}"

    #Conda
if [ ! -f "$installerPath" ]; then #If the installer doesn't exist, install it
    echo -e "${GREEN}Downloading Miniconda installer...${NC}"
    download "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" "$installerPath"
fi
echo -e "${GREEN}Keeping all default configuration options within the MiniConda installer${NC}"
if [ ! -d "$miniCondaPath" ]; then #If you don't have miniconda, install it
    installArgs=(-b -p "$miniCondaPath") #AI-Genned Line
    bash "$installerPath" "${installArgs[@]}" #-b runs the installer in silent/batch mode, equivalent of -NoNewWindow
fi
echo -e "${RED}Do not restart the terminal${NC}"

#Conda Initialization
echo -e "${GREEN}Sucessfully setup MiniConda... Initializing to Bash${NC}"
"$condaExe" init bash
"$condaExe" clean --all --force-pkgs-dirs --yes

#VSCode Initialization
while IFS= read -r extension; do code --install-extension "$extension"; done < vsExtensions.txt #AI-Genned Line

#Accepting TOS
"$condaExe" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
"$condaExe" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
"$condaExe" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2
# conda clean --all --force-pkgs-dirs


#Dir Setup
echo -e "${GREEN}Miniconda Initialized, Generating subdirectory${NC}"
mkdir "PackageSet1"
cd "./PackageSet1"
"$condaExe" create --prefix "./.venv" python=$pythonVer --yes
"$condaExe" install --prefix "./.venv" --file "../packages.txt" --name PackageSet1 --yes

#VSCode Setup
mkdir "./.vscode"
cp "../settings.json" "./.vscode"
code -n "."

#Completion
cd ..
echo -e "${GREEN}Sucessfully installed conda, generated an environment, and booted VSCode${NC}"
echo -e "${GREEN}Cleaning up...${NC}"
rm "$installerPath"
rm "./VSCodeUserSetup.tar.gz"

echo -e "${RED}Cleanup complete${NC}"
