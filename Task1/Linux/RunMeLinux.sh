#!/bin/bash

#Var Dump (Copied from installation script)
miniCondaPath="$HOME/miniconda3"
venvPath="./PackageSet1/.venv"
#Bools
vsIsInstalled=false
condaIsInstalled=false
venvSetup=false

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

#Installation Verification
echo -e "${GREEN}Verifying Installation..${NC}"
    #VSCode
if command -v code &> /dev/null; then
    echo -e "${GREEN}VSCode is installed!${NC}"
    vsIsInstalled=true
    echo -e "${GREEN}VSCode connection established, proceeding${NC}"
else
    echo -e "${RED}VSCode isn't installed${NC}"
fi

    #Conda
if [ -d "$miniCondaPath" ]; then #If miniconda, mark bool
    echo -e "${GREEN}Conda is installed!${NC}"
    condaIsInstalled=true
else
    echo -e "${RED}Conda isn't installed${NC}"
fi
    #Virtual Environment
if [ -d "$venvPath" ]; then #If virtual environment exists
    echo -e "${GREEN}Virtual Environment is Established!${NC}"
    venvSetup=true
fi

#Run/Install
if $vsIsInstalled && $condaIsInstalled && $venvSetup; then
    # FEATURE TO ADD: Ability to reset the virtual environment if all pieces are installed correctly
    echo -e "${CYAN}Booting VSCode...${NC}"
    cd "./PackageSet1"
    code -n "."
else
    read -p "Error: Installation not completed, begin installation process? (Expected Installation time ~5mins) y/n " userResponse
    if [ "$userResponse" == "y" ]; then
        echo -e "${GREEN}Beginning installation Process...${NC}"
        ./LinuxInstaller.sh
    elif [ "$userResponse" == "n" ]; then
        echo -e "${RED}Script shutting down${NC}"
    else
        echo -e "${RED}Invalid Response${NC}"
    fi
fi
echo -e "${RED}Goodbye${NC}"
