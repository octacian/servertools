#! /bin/bash
#
#CREDIT:
# Source Code: Elijah Duffy
# Contact: enduffy2014@outlook.com
#
#LICENSE:
# Copywrite 2016 enDEV. YOU MAY NOT UNDER ANY CIRCUMSTANCES EDIT, COPY, REDISTRIBUTE
# OR REPRODUCE THIS [CODE] IN ANY WAY WITHOUT DIRECT PERMISSION OF THE ORIGINAL
# AUTHOR (Elijah Duffy).

# Name of mod to be installed
modname="server_tools"

# Pre-Start Subgame Specification
subgame="$1"

# Default Root Directory
rootDIR="/usr/share/games/minetest"

# Default Minetest Root Directory cannot be Located
rootError() {
  echo "Fatal error: ${error}."
  echo "Minetest root directory cannot be located. Please fix this error before continuing."
  echo ""
  read -p "You may: (e)xit or set a (c)ustom root directory : " rootChoice
  if [[ $rootChoice == "e" ]]
    then
      echo ""
    else
      clear
      read -p "Enter the full path to your custom Minetest root directory : " rootDIR
  fi
}

# Subgame Directory cannot be Located
subLost() {
  echo "Error: ${error}."
  echo "${subgame} subgame directory cannot be located."
  echo ""
  read -p "Press enter to select a new subgame : " null
  subStall;
}

# Dirrectory cannot be Located
fileError() {
  echo "Error: ${error}."
  echo "${errorName} directory cannot be located. Please fix this before continuing."
}

# Previous Installation Error
previousInstallFound() {
  clear
  printf '\e[8;24;80t'
  echo "A previous installation of the ${modname} mod has neen found."
  read -p "Press enter to remove the old installation and continue : " null
  sudo rm -r ${rootDIR}/games/${subgame}/mods/${modname}
  midCheck;
}

# Directory(s) Accessible Pre Check
preCheck() {
  clear
  printf '\e[8;24;80t'
  # Check for default Minetest Root DIR
  if [[ -d "${rootDIR}" ]]
    then
      echo "Minetest root directory located..."
    else
      error="f001"
      rootError;
  fi

  # Check for subgames directory
  if [[ -d "${rootDIR}/games" ]]
    then
      echo "Minetest subgames directory located..."
    else
      error="d010"
      errorName="Minetest subgames"
      fileError;
  fi

  # Get working DIR
  echo "Acquiring current working directory..."
  cwd=$(pwd)

  # Continue
  subStall;
}

# Ask for subgame based install location
subStall() {
  clear
  printf '\e[8;24;80t'
  echo "================================================================================"
  echo "|                                 Install to...                                |"
  echo "================================================================================"
  echo "Choose a subgame to install the ${modname} mod to:"
  cd ${rootDIR}/games
  ls
  read -p "Please enter the full name from the list above : " subgame

  # Continue
  midCheck;
}

midCheck() {
  clear
  printf '\e[8;24;80t'

  # Check specified subgame DIR
  if [[ -d "${rootDIR}/games/${subgame}" ]]
    then
      echo "Subgame directory located..."
    else
      error="d020"
      errorName="${subgame}"
      subLost;
  fi

  # Check for mods DIR
  if [[ -d "${rootDIR}/games/${subgame}/mods" ]]
    then
      echo "Mods directory located..."
    else
      error="d030"
      errorName="Mods"
      fileError;
  fi

  # Check for previous installation
  if [[ -d "${rootDIR}/games/${subgame}/mods/${modname}" ]]
    then
      echo "Previous installation found..."
      previousInstallFound;
    else
      echo "No previous installation found..."
  fi

  # Continue
  install;
}

install() {
  clear
  printf '\e[8;24;80t'
  echo "================================================================================"
  echo "|                                  Installing                                  |"
  echo "================================================================================"
  echo "Copying files..."
  sudo cp -r ${cwd} /${rootDIR}/games/${subgame}/mods/server_tools
  echo "Changing file access rights..."
  sudo chown -R root:root /${rootDIR}/games/${subgame}/mods/server_tools
  sudo chmod -R +r /${rootDIR}/games/${subgame}/mods/server_tools
  sudo chmod -R +x /${rootDIR}/games/${subgame}/mods/server_tools
  echo ""
  echo "The installation is complete. The script will now exit."
}

preCheck;
