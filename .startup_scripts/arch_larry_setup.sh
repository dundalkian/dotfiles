
# Get an internet connection
#sudo apt update
#sudo apt install git
#cd ~
#git clone https://github.com/dundalkian/dotfiles.git
#cd dotfiles/.startup_scripts
#sh arch_larry_setup.sh

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
git config --global user.email "larrysteele117@gmail.com"
git config --global user.name "Larry Steele"

sudo pacman -Syu
for target in sl vim zsh htop neofetch tree stow tldr curl awk sed i3 rxvt-unicode feh xorg-server xorg-xinit compton python-pip firefox
do
    sudo pacman -S $target --noconfirm
done

for target in pywal
do
    sudo pip3 install $target
done

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
echo ALL DONE.

