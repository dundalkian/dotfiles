
pacman -S sudo
useradd -m larry
echo "larry ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo
echo "larry ALL=(root) NOPASSWD: /usr/bin/powertop, /usr/bin/rfkill" | sudo EDITOR='tee -a' visudo
cd /home/larry
