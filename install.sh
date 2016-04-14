#! /bin/bash
#
#LICENSE:
# Copyright (c) 2016 Elijah Duffy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#GENERIC VARIABLES
# Name of mod to be installed
modname="server_tools"

# Pre-Start Subgame Specification
subgame="$1"
#END: GENERIC VARIABLES

#GENERIC FUNCTIONS
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
  echo "A previous installation of the ${modname} mod has been found."
  read -p "Press enter to remove the old installation and continue : " null
  sudo rm -r ${rootDIR}/games/${subgame}/mods/${modname}
  midCheck;
}
#END: GENERIC FUNCTIONS

# Check Root DIRs for Version
version() {
  clear
  printf '\e[8;24;80t'
  echo "Determining Minetest Version..."

  # Confirm Version with User
  confirmV() {
    clear
    printf '\e[8;24;80t'
    echo "================================================================================"
    echo "|                                    Version                                   |"
    echo "================================================================================"
    read -p "Please confirm that your Minetest installation is version 0.4.13 (y/n) : " prompt
    echo ""
    if [[ $prompt == "y" ]]
      then
        preCheck;
      else
        echo "Version Set to 0.4.12 or Older..."
        rootDIR="/usr/share/games/minetest"
        echo "RootDIR = ${rootDIR}"
        sleep 2
        preCheck;
    fi
  }

  #Check for DIR in /usr/local/share/games/minetest
  if [[ -d "/usr/local/share/minetest" ]]
    then
      echo "v0.4.13 Root DIR Located..."
      rootDIR="/usr/local/share/minetest"
      version="0.4.13"
      confirmV;
    elif [[ -d "/usr/share/games/minetest" ]]
      then
        echo "v0.4.12 Root DIR Located..."
        rootDIR="/usr/share/games/minetest"
        version="0.4.12"
        preCheck;
    else
      echo "No Root DIR Located..."
      sleep 2
      rootError;
  fi
}

# # Check DIRs Accessible
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
  # Check is subgame has been specified through $1
  if [[ $subgame == "" ]]
    then
      # Run subAsk()
      subAsk;
    else
      # Continue
      midCheck;
  fi

  subAsk() {
    # Interactive subgame determining
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
}

# Check DIRs Entered
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
  sudo cp -r ${cwd} /${rootDIR}/games/${subgame}/mods/${modname}
  echo "Changing file access rights..."
  sudo chown -R root:root ${rootDIR}/games/${subgame}/mods/${modname}
  sudo chmod -R +r ${rootDIR}/games/${subgame}/mods/${modname}
  sudo chmod -R +x ${rootDIR}/games/${subgame}/mods/${modname}
  echo ""
  echo "The installation is complete. The script will now exit."
}

version;
