# RebuiltFedora XFCE Kickstart
# Lightweight Fedora 44 desktop configuration

lang en_US.UTF-8
keyboard us
timezone America/New_York --utc

# livemedia-creator requires a supported install source and active networking.
network --bootproto=dhcp --device=link --activate
url --url=https://download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/

# Use an explicit root partition. livemedia-creator needs a concrete / partition
# when it calculates the temporary disk image size; autopart alone is not enough
# for this build path.
clearpart --all --initlabel
part / --fstype="ext4" --size=12288 --grow

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
dracut-live
%end

%post
systemctl enable NetworkManager
systemctl enable firewalld
systemctl set-default graphical.target

# Create the development user
useradd -m -G wheel rebuilt
passwd -d rebuilt

# Install the RebuiltFedora Fastfetch configuration and shared ASCII branding.
install -Dm644 /workspace/branding/tux.txt /etc/rebuiltfedora/tux.txt 2>/dev/null || true
mkdir -p /etc/fastfetch
cat > /etc/fastfetch/config.jsonc <<'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/wiki/Jsonc-Schema",
  "logo": {
    "type": "file",
    "source": "/etc/rebuiltfedora/tux.txt"
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "display",
    "de",
    "wm",
    "cpu",
    "gpu",
    "memory",
    "disk",
    "localip",
    "break",
    "colors"
  ]
}
EOF

# Make the shared Tux artwork available to future ASCII-capable tools.
mkdir -p /usr/share/rebuiltfedora/ascii
cp /etc/rebuiltfedora/tux.txt /usr/share/rebuiltfedora/ascii/tux.txt 2>/dev/null || true
%end
