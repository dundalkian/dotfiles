# This portion will have to be run by hand, but still walks through the process.
# Creating a custom iso at some point for bionicdog will remove this requirement.

# Get an internet connection
#sudo apt update
#sudo apt install git
#cd ~
#git clone https://github.com/dundalkian/dotfiles.git
# enter github username (This won't be necessary when this is no longer a private repo)
# enter github password (hint, the less patriotic one)
#cd dotfiles/.startup_scripts
#sh ubuntu_18.04.1_larry_setup.sh

# Shall we begin? 
cd ~

## Sway setup ##
# https://github.com/swaywm/sway/wiki/Debian-installation-guide
# Wayland
sudo apt install libgles2-mesa-dev libdrm2 libdrm-dev libegl1-mesa-dev xwayland

# Wlc install
sudo apt install cmake build-essential libinput10 libinput-dev libxkbcommon0 libxkbcommon-dev libudev-dev libxcb-image0 libxcb-image0-dev libxcb-composite0 libxcb-composite0-dev libxcb-xkb1 libxcb-xkb-dev libgbm1 libgbm-dev libdbus-1-dev libsystemd-dev zlib1g-dev libpixman-1-dev libxcb-ewmh-dev wayland-protocols
cd Downloads
git clone https://github.com/Cloudef/wlc.git
cd wlc
git submodule update --init --recursive
mkdir target
cd target
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DSOURCE_WLPROTO=ON ..
make
sudo make install

# Sway
sudo apt-get install libpcre3 libpcre3-dev libcairo2 libcairo2-dev libpango1.0-0 libpango1.0-dev asciidoc libjson-c3 libjson-c-dev libcap-dev xsltproc libpam0g-dev
git clone https://github.com/SirCmpwn/sway.git
cd sway/
git checkout 0.15
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc ..
make
sudo make install

## End Sway Setup ##

# Less vital packages
sudo apt remove vim-tiny vim-common
sudo apt install vim zsh htop neofetch

