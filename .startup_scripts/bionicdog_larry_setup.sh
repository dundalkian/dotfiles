# This portion will have to be run by hand, but still walks through the process.
# Creating a custom iso at some point for bionicdog will remove this requirement.

# 1. Get an internet connection
# 2. starts as root so ...

#apt update
#apt install git
#cd /home/puppy
#git clone https://github.com/dundalkian/dotfiles.git
# enter github username
# enter github password (hint, the less patriotic one)
#cd dotfiles/.startup_scripts
#sh bionicdog_larry_setup.sh


# Shall we begin?

# Needed to symlink all of the configuration files
apt install stow


# Packages not required by install 
apt install zsh man-db





