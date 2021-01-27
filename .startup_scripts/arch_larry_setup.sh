
# Install Arch

sudo bash -c 'cat /root/dotfiles/.startup_scripts/Premade_Files/iwd_main.conf > /etc/iwd/main.conf'

sudo systemctl start iwd
sudo systemctl start systemd-resolved

sudo systemctl enable iwd
sudo systemctl enable systemd-resolved

sudo iwctl
sudo pacman -Syu
cd ~
git clone https://github.com/dundalkian/dotfiles.git

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



all=0
install_group()
{
    if [[ $all -eq 1 ]]
    then
        sudo pacman -S "$1" --noconfirm
    else
        echo Install group: "$1" to your system? [y/n]
        read choice
    
        if [ "$choice" = y ]
        then
            echo Installing...
            sudo pacman -S $1
        elif [ "$choice" = "all" ] 
        then
            echo setting all packages to download, sit back and grab a coffee
            all="1"
        else
            echo Skipping install
        fi
    fi
}
sudo pacman -Syu --noconfirm

# dmenu             : application launcher and universal selection tool
# w3m               : image drawing package for ranger image previews
# ranger            : extensible file browser. vim-like
# zathura           : feature-full pdf viewer. vim-like
# zathura-pdf-mudf  : zathura extension using the mupdf backend
# tldr              : simplified and community-driven manpages. This is a cli client for tldr


# High priority personally
systargets="vim htop stow"

# Needed to setup X 
xtargets="dmenu i3-gaps i3blocks i3lock i3status rxvt-unicode xorg-server xorg-xinit"

productivitytargets="zathura zathura-pdf-mupdf"

beautytargets="ttf-hack python-pywal feh scrot neofetch"

networking="openssh"

gvim="gvim"

ranger="ranger w3m"

clitargets="powertop tldr"

# Had some issues with my current card using nouveau.
#nv="xf86-video-nouveau"
nv="nvidia"
amd="xf86-video-amdgpu"

for group in "$systargets" "$xtargets" "$productivitytargets" "$beautytargets" "$gvim" "$ranger" "$clitargets" "$nv" "$amd"
do
    install_group "$group"
done

# Sometime after this summer password based auth for github will fail
# so I'll need to work in some sort of auto-ssh key import. Or import
# the personal access tokens.
git config --global user.email "larrysteele117@gmail.com"
git config --global user.name "Larry Steele"

sudo pacman -Syu

# Sets up some default targets for mounting other drives
# Helpful for the dmenu mount script
cd /mnt
sudo mkdir usb0 usb1 usb2 usb3 hd0 hd1 hd2 hd3 windows linux
cd ~

# loads libinput config file that will allow for realistic (reversed) scrolling in X
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo cp ~/dotfiles/.startup_scripts/Premade_Files/30-touchpad.conf /etc/X11/xorg.conf.d/

# loads kernel driver configuration file to limit audio power usage
sudo cp ~/dotfiles/.startup_scripts/Premade_Files/idle-audio.conf

sudo cp ~/dotfiles/.startup_scripts/Premade_Files/10-my-modifiers.hwdb /etc/udev/hwdb.d/
# Removes the 3 second pause after a failed PAM authentication
~/dotfiles/.startup_scripts/remove_pam_fail_delay



echo Install dotfiles to your home directory? [y/n]
read choice

if [ "$choice" = y ]
then
echo Removing existing dotfiles and symlinking dotfiles to home...
stow_dots
cd ~
else
echo Skipping dotfile install
fi

cd ~ 
mkdir Builds
mkdir Dev
#sh ~/dotfiles/.startup_scripts/apply_st_patches
sudo chown -R larry /home/larry/

echo ALL DONE.

