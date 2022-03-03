#!/usr/bin/env bash

# ref: https://github.com/mathiasbynens/dotfiles/blob/master/.macos

echo "Applying macOS system settings..."

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Warn that some commands will not be run if the script is not run as root.
if [[ $EUID -ne 0 ]]; then
  RUN_AS_ROOT=false
  printf "Certain commands will not be run without sudo privileges. To run as root, run the same command prepended with 'sudo', for example: $ sudo $0\n\n" | fold -s -w 120
else
  RUN_AS_ROOT=true
  # Update existing `sudo` timestamp until `.osx` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi


###############################################################################
# Energy saving                                                               #
###############################################################################

# Restart automatically if the computer freezes
# if [[ "$RUN_AS_ROOT" = true ]]; then sudo systemsetup -setrestartfreeze on; fi

# Enable lid wakeup
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -a lidwake 1; fi

# Restart automatically on power loss
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -a autorestart 1; fi

# Sleep the display after x minutes
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -a displaysleep 15; fi

# Set machine sleep while charging
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -c sleep 0; fi

# Set machine sleep on battery
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -b sleep 30; fi

# Set standby delay to 24 hours (default is 1 hour)
if [[ "$RUN_AS_ROOT" = true ]]; then sudo pmset -a standbydelay 86400; fi

# Never go into computer sleep mode
if [[ "$RUN_AS_ROOT" = true ]]; then sudo systemsetup -setcomputersleep Off > /dev/null; fi

# # Hibernation mode
# # 0: Disable hibernation (speeds up entering sleep mode)
# # 3: (default) Copy RAM to disk so the system state can still be restored
# #    in case of a power failure.
# if [[ "$RUN_AS_ROOT" = true ]]; then sudo  pmset -a hibernatemode 0; fi

# # Remove the sleep image file to save disk space
# if [[ "$RUN_AS_ROOT" = true ]]; then sudo rm /private/var/vm/sleepimage; fi
# # Create a zero-byte file instead…
# if [[ "$RUN_AS_ROOT" = true ]]; then sudo touch /private/var/vm/sleepimage; fi
# # …and make sure it can't be rewritten
# if [[ "$RUN_AS_ROOT" = true ]]; then sudo chflags uchg /private/var/vm/sleepimage; fi

###############################################################################
# Screen                                                                      #
###############################################################################

# Enable HiDPI display modes (requires restart)
if [[ "$RUN_AS_ROOT" = true ]]; then
  sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true;
fi

###############################################################################
# Spotlight                                                                   #
###############################################################################

killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
if [[ "$RUN_AS_ROOT" = true ]]; then sudo mdutil -i on / > /dev/null; fi
# Rebuild the index from scratch
if [[ "$RUN_AS_ROOT" = true ]]; then sudo mdutil -E / > /dev/null; fi

###############################################################################
# Kill/restart affected applications                                          #
###############################################################################

# Restart affected applications if `--no-restart` flag is not present.
if [[ ! ($* == *--no-restart*) ]]; then
   for app in "cfprefsd" \
    "SystemUIServer" \
    "mds"; do
    killall "${app}" &> /dev/null
  done
fi

printf "Please log out and log back in to make all settings take effect.\n"
