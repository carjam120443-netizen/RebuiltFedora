# RebuiltFedora XFCE Kickstart
# Initial lightweight Fedora desktop configuration

lang en_US.UTF-8
keyboard us
timezone America/New_York --utc

%packages
@xfce-desktop-environment
@base-x
NetworkManager
NetworkManager-wifi
firewalld
sudo
vim-minimal
nano
curl
wget
git
fastfetch
%end

%post
systemctl enable NetworkManager
systemctl enable firewalld
systemctl set-default graphical.target

# Create the development user
useradd -m -G wheel rebuilt
passwd -d rebuilt
%end
