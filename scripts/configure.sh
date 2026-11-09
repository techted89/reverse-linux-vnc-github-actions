#!/bin/bash
# Reverse Linux VNC for GitHub Actions by PANCHO7532
# This script is executed when GitHub actions is initialized.
# Prepares dependencies, ngrok, tailscale, and vnc stuff

# First, install required packages...
sudo apt update
sudo apt install -y xfce4 xfce4-goodies xfonts-base xubuntu-icon-theme xubuntu-wallpapers gnome-icon-theme x11-apps x11-common x11-session-utils x11-utils x11-xserver-utils x11-xkb-utils dbus-user-session dbus-x11 gnome-system-monitor gnome-control-center libpam0g libxt6 libxext6

# Second, install TurboVNC
# Fun Fact: TurboVNC is the only VNC implementations that supports OpenGL acceleration without an graphics device by default
# By the way, you can still use the legacy version of this script where instead of installing TurboVNC, tightvncserver is installed.
wget 'https://github.com/TurboVNC/turbovnc/releases/download/3.3.1/turbovnc_3.3.1_amd64.deb'
sudo dpkg -i turbovnc_3.3.1_amd64.deb

# Third, download ngrok

echo $PWD
pwd
ls -laR

# Get the absolute path of the directory where configure.sh lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run another script in the same folder
chmod +x ./scripts/Ngrok-Installer.sh
./scripts/Ngrok-Installer.sh

# Fourth, install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Fifth, generate and copy passwd file and xstartup script
export PATH=$PATH:/opt/TurboVNC/bin
mkdir $HOME/.vnc
cp ./resources/xstartup $HOME/.vnc/xstartup.turbovnc
echo $VNC_PASSWORD | vncpasswd -f > $HOME/.vnc/passwd
chmod 0600 $HOME/.vnc/passwd

# Sixth, Tailscale is started by the workflow step
# (see .github/workflows/linux-vnc.yml "Starting Tailscale..." step)
# Seventh, set up auth token from argument
ngrok authtoken $NGROK_AUTH_TOKEN
exit