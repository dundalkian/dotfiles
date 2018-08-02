
# Get an internet connection
#sudo apt update
#sudo apt install git
#cd ~
#git clone https://github.com/dundalkian/dotfiles.git
#cd dotfiles/.startup_scripts
#sh ubuntu_18.04.1_larry_setup.sh

# insert Fine,_I'll_do_it_myself.gif
manually_install()
{
cd ~/Downloads
# shouldn't be needed anymore
#sudo apt-get install -y $target 2>&1 | grep -Po "(?<=fetch ).*(?=  Redirection)" | xargs wget 2>&1 | grep -Po "(?<= - ‘).*(?=’ saved)" | sudo xargs dpkg -i 
sudo apt install -f
sudo apt update
sudo apt upgrade
}

install_sway()
{
    # https://github.com/swaywm/sway/wiki/Debian-installation-guide
    # Wayland
    for target in libgles2-mesa-dev libdrm2 libdrm-dev libegl1-mesa-dev xwayland
    do
        sudo apt install $target
    done
    # Wlc install
    for target in build-essential libinput10 libinput-dev libxkbcommon0 libxkbcommon-dev libudev-dev libxcb-image0 libxcb-image0-dev libxcb-composite0 libxcb-composite0-dev libxcb-xkb1 libxcb-xkb-dev libgbm1 libgbm-dev libdbus-1-dev libsystemd-dev zlib1g-dev libpixman-1-dev libxcb-ewmh-dev wayland-protocols
    do    
        sudo apt install $target
    done
    cd ~/Downloads
    git clone https://github.com/Cloudef/wlc.git
    cd wlc
    git submodule update --init --recursive
    mkdir target
    cd target
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DSOURCE_WLPROTO=ON ..
    make
    sudo make install

    # Sway
    for target in libpcre3 libpcre3-dev libcairo2 libcairo2-dev libpango1.0-0 libpango1.0-dev asciidoc libjson-c3 libjson-c-dev libcap-dev xsltproc libpam0g-dev
    do    
        sudo apt install $target
    done    
    cd ~/Downloads
    git clone https://github.com/SirCmpwn/sway.git
    cd sway
    git checkout 0.15
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc ..
    make
    sudo make install
}

stow_dots()
{
    cd ~/dotfiles
    # Remove any existing configuration folders/files that we plan to symlink 
    # (Stow is a very ... unconfrontational command?)
    #
    # Lets break this shit down because I just had to learn basically every character
    # in this command and I know I will forget.
    #
    # -P .  says to not follow symlinks and to start in this directory
    # -maxdepth 2 -mindepth 2  says every folder and file exactly 2 levels down should
    # have its mirror in the home directory removed. This is a result of the structure
    # of the dotfiles repo: {~/dotfiles/zsh/.zshrc} replaces {~/.zshrc} for example
    # ! -path "./.*"  says to not include any first level folder/file with a .dot name
    # {~/dotfiles/zsh/.zshrc} will look like ./zsh/.zshrc and we don't want ./.git/* files
    # This means that any folders not to be stowed can be marked with a .dot
    # | awk -F/ '{print $3}'  pipe output and split on the '/' character (F = Field Separator)
    # print the third column ./zsh/.zshrc becomes [., zsh, .zshrc]
    # xargs -I"{}"  replace all instances of that string {} with stdin
    # rm -rf ~/{}  recursively delete everything in the home directory that is passed in
    # for example will delete ~/.vim/* as well as ~/.zshrc
    find -P . -maxdepth 2 -mindepth 2  ! -path "./.*" | \
    awk -F/ '{print $3}' | xargs -I"{}" rm -rf ~/{}
    # Most of this folows from the last command, we want to stow
    # all top level folders that aren't .dots
    # The sed command is equivalent to sed 's|./||' I believe, replacing './' with ''	
    find -P . -maxdepth 1 ! -path "./.*" ! -path "." | sed 's/.\///' | xargs stow
}

 
cd ~
# Adding desired repos
sudo apt-add-repository universe multiverse main restricted 

# I have problems with my default DNS so lets change it up.
sudo apt install resolvconf
# Echo loud
sudo sh -c 'echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolvconf/resolv.conf.d/head'
sudo resolvconf -u

# Will need 'stow' to symlink dotfiles to home directory
sudo apt update
sudo apt upgrade 
for target in sl vim zsh htop neofetch tree stow make cmake tldr gdebi curl vlc tee virtualbox virtualbox-ext-pack python  
do
    sudo apt install $target
done
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# Echo soft
if grep "google" "/etc/apt/sources.list" 
then
    echo Google repository already added to /etc/apt/sources.list!
else
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list'
fi
sudo apt update
sudo apt install google-chrome-stable
xdg-mime default google-chrome.desktop text/html
xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop x-scheme-handler/https
xdg-mime default google-chrome.desktop x-scheme-handler/about




echo Install dotfiles to your home directory? [y/n]
read choice

if [ $choice = y ]
then 
echo Removing existing dotfiles and symlinking dotfiles to home...
stow_dots
cd ~
else 
echo Skipping dotfile install
fi


# Dealing with Sway and Wayland currently seems to be quite annoying, expecting it to break often
echo Do you want to install the Sway tiling Wayland compositor? [y/n]
read choice

if [ $choice = y ]
then 
echo Installing Wayland, Wlc, and Sway...
install_sway
cd ~
echo If any packages had redirect errors, we tried to install them manually, be sure to check your Downloads folder to remove any uneeded .deb packages.
fi



