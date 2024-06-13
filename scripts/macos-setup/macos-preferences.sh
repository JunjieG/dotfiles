#!/bin/bash

##############################################################################
# Applies MacOS settings and preferences in /Library/Preferences             #
# Covers Spotlight, layout, colors, fonts, mouse, keyboard and shortcuts     #
#                                                                            #
# CAUTION: This script will apply changes to your OS X system configuration  #
# Be sure to read it through carefully, and remove anything you don't want.  #
#                                                                            #
# Options:                                                                   #
#   --silent     - Don't log any status outputs                              #
#   --skip-intro - Skip the warning and intro section                        #
#   --yes-to-all - Don't prompt user to agree to changes                     #
#                                                                            #
# Licensed under MIT -  (C) Alicia Sykes 2022 <https://aliciasykes.com>      #
##############################################################################

############################################################
# Initialize variables, check requirements, and print info #
############################################################

# Record start time
start_time=`date +%s`

# Get params
params="$params $*"

# Color variables
PRIMARY_COLOR='\033[1;33m'
ACCENT_COLOR='\033[0;34m'
INFO_COLOR='\033[0;30m'
INFO_COLOR_U='\033[4;30m'
SUCCESS_COLOR='\033[0;32m'
WARN_1='\033[1;31m'
WARN_2='\033[0;31m'
RESET_COLOR='\033[0m'

# Current and total taslks, used for progress updates
current_event=0
total_events=70

# Check system is compatible
if [ ! "$(uname -s)" = "Darwin" ]; then
  echo -e "${PRIMARY_COLOR}Incompatible System${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}This script is specific to Mac OS,\
  and only intended to be run on Darwin-based systems${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}Exiting...${RESET_COLOR}"
  exit 1
fi

# Print info, and prompt for confrimation
if [[ ! $params == *"--skip-intro"* ]]; then
  # Output what stuff will be updated
  echo -e "${PRIMARY_COLOR} MacOS User Preferences${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}The following sections will be executed:"
  echo -e " - Device info"
  echo -e " - Localization"
  echo -e " - UI Settings"
  echo -e " - Opening, saving and printing files"
  echo -e " - System power and lock screen options"
  echo -e " - Sound and display quality"
  echo -e " - Keyboard and input"
  echo -e " - Mouse and trackpad"
  echo -e " - Spotlight and search"
  echo -e " - Dock and Launchpad"

  # Inform user what they're running, and cautions them to read first
  echo -e "\n${INFO_COLOR}You are running ${0} on\
  $(hostname -f | sed -e 's/^[^.]*\.//') as $(id -un)${RESET_COLOR}"
  echo -e "${WARN_1}IMPORTANT:${WARN_2} This script will make changes to your system.\
  Ensure you've read it through before continuing${RESET_COLOR}"

  # Ask for user confirmation before proceeding (if skip flag isn't passed)
  if [[ ! $params == *"--yes-to-all"* ]]; then
    echo -e "\n${PRIMARY_COLOR}Would you like to proceed? (y/N)${RESET_COLOR}"
    read -t 15 -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${ACCENT_COLOR}\nNo worries, nothing will be applied - feel free to come back another time."
      echo -e "${PRIMARY_COLOR}Exiting...${RESET_COLOR}"
      exit 0
    fi
  fi
fi

# Check have got admin privilages
if [ "$EUID" -ne 0 ]; then
  echo -e "${ACCENT_COLOR}\nElevated permissions are required to adjust system settings."
  echo -e "${PRIMARY_COLOR}Please enter your password...${RESET_COLOR}"
  script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
  params="--skip-intro ${params}"
  sudo "$script_path" $params || (
    echo -e "${ACCENT_COLOR}Unable to continue without sudo permissions"
    echo -e "${PRIMARY_COLOR}Exiting...${RESET_COLOR}"
    exit 1
  )
  exit 0
fi

# Helper function to log progress to console
function log_msg () {
  current_event=$(($current_event + 1))
  if [[ ! $params == *"--silent"* ]]; then
    if (("$current_event" < 10 )); then sp='0'; else sp=''; fi
    echo -e "${PRIMARY_COLOR}[${sp}${current_event}/${total_events}] ${ACCENT_COLOR}${1}${INFO_COLOR}"
  fi
}

# Helper function to log section to console
function log_section () {
  if [[ ! $params == *"--silent"* ]]; then
    echo -e "${PRIMARY_COLOR}[INFO ] ${1}${INFO_COLOR}"
  fi
}

echo -e "\n${PRIMARY_COLOR}Starting...${RESET_COLOR}"

# Vzariables for system preferences
COMPUTER_NAME="Eric's-MacBook"
HIGHLIGHT_COLOR="0 0.8 0.7"

# Quit System Preferences before starting
osascript -e 'tell application "System Preferences" to quit'

# Keep script alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###################
# Set Device Info #
###################
log_section "Device Info"

# Set computer name and hostname
log_msg "Set computer name"
sudo scutil --set ComputerName "$COMPUTER_NAME"

log_msg "Set remote hostname"
sudo scutil --set HostName "$COMPUTER_NAME"

log_msg "Set local hostname"
sudo scutil --set LocalHostName "$COMPUTER_NAME"

log_msg "Set SMB hostname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

############################
# Location and locale info #
############################
log_section "Local Preferences"

log_msg "Set language to English"
defaults write NSGlobalDomain AppleLanguages -array "en"

log_msg "Set units to metric"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

##################
# File Locations #
##################
log_section "File Locations"

log_msg "Set location to save screenshots to"
defaults write com.apple.screencapture location -string "${HOME}/Downloads/screenshots"

log_msg "Save screenshots in .png format"
defaults write com.apple.screencapture type -string "png"

#####################################
# System Power, Resuming, Lock, etc #
#####################################
log_section "System Power and Lock Screen"

log_msg "Add host info to the login screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

##############################
# Sound and Display Settings #
##############################
log_section "Sound and Display"

log_msg "Increase sound quality for Bluetooth devices"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

log_msg "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 1

log_msg "Enable HiDPI display modes"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

########################
# Keyboard, Text Input #
########################
log_section "Keyboard and Input"

log_msg "Disable automatic text capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

log_msg "Disable automatic dash substitution"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

log_msg "Disable automatic periord substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

log_msg "Disable automatic period substitution"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

log_msg "Disable automatic spell correction"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_msg "Enable full keyboard navigation in all windows"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

#####################################
# Print finishing message, and exit #
#####################################
echo -e "${PRIMARY_COLOR}\nFinishing...${RESET_COLOR}"
echo -e "${SUCCESS_COLOR}✔ ${current_event}/${total_events} tasks were completed \
succesfully in $((`date +%s`-start_time)) seconds${RESET_COLOR}"
echo -e "\n${PRIMARY_COLOR}         .:'\n     __ :'__\n  .'\`__\`-'__\`\`.\n \
:__________.-'\n :_________:\n  :_________\`-;\n   \`.__.-.__.'\n${RESET_COLOR}"

if [[ ! $params == *"--quick-exit"* ]]; then
  echo -e "${ACCENT_COLOR}Press any key to continue.${RESET_COLOR}"
  read -t 5 -n 1 -s
fi
exit 0
