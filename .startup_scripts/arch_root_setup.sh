
pacman -S sudo
useradd -m larry
echo "larry ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo
cd /home/larry
