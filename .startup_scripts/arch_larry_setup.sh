
# Install Arch

# When in chroot, install:
# netctl (should be installed)
# wpa_supplicant
# dialog
#
# This gives access to the wifi-menu feature of netctl, 
# which is pretty great to be honest, makes profile management easier.

#sudo pacman -Syu
#sudo pacman -S install git
#git clone https://github.com/dundalkian/dotfiles.git

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

# We have manually created a profile but it will not be loaded at boot
# gets the profile we set up and enables the systemd unit for that profile
profile=$(netctl list | awk '{print $2}')
sudo netctl enable $profile

# TODO test profile status and ping something to check connection
sudo pacman -Syu --noconfirm

for target in ttf-hack vim htop stow sed rxvt-unicode xorg-server xorg-xinit compton python-pip
do
	sudo pacman -S $target --noconfirm
done


cd ~
git config --global user.email "larrysteele117@gmail.com"
git config --global user.name "Larry Steele"

sudo pacman -Syu


for target in 
do
    sudo pacman -S $target --noconfirm
done

for target in pywal
do
    sudo pip3 install $target
done

## Install oh-my-zsh
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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


sudo chown -R larry /home/larry/
echo ALL DONE.

