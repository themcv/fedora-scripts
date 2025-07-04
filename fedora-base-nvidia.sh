#!/bin/bash
# This script is to install the basics on a new Fedora box. 
# I am not responsible for if things break or it doesn't work.
# This script is not a substitue for not knowing what is going on.

# Set variables

fv=$(cat /etc/os-release | grep VERSION_ID | cut -d = -f2)
UPDATES=$(dnf check-update --quiet | grep -Ev 'Last metadata expiration|^$' | wc -l)
sb=$(mokutil --sb-state | grep disabled | wc -l)
nv=$(modinfo -F version nvidia)

# Check if SecureBoot is enabled
if [ "$sb" -lt 1 ]; then
    echo "SecureBoot is currently enabled"
    echo "This script does not support having SecureBoot enabled at this time"
    echo "Please disable SecureBoot before running it again"
    break
else
    echo "SecureBoot is disabled."
    
# Check and make sure that system is up to date
# Update the system
echo "Checking for updates before continuing"

if [ "$UPDATES" -gt 0 ]; then
    echo "$UPDATES updates available. Applying updates..."

    # Apply all available updates without prompting
    dnf update -y

    echo "You will need to reboot before continuing! Otherwise the NVIDIA drivers will not compile right"

    # Stop processing the script
    break
    
else
    echo "No updates available. Continuing script execution..."
    # Continue with the rest of your script here
fi


# Install the RPM fusion repos
echo "Installing RPM fusion free repos for Fedora $fv"
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$fv.noarch.rpm

echo "Installing RPM fusion non-free repos for Fedora $fv"
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fv.noarch.rpm

# Start the QOL stuff

echo "Swapping ffmpeg"
dnf swap ffmpeg-free ffmpeg --allowerasing

echo "Installing Multimedia codecs"
dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

echo "Installing VAAPI"
dnf install libva-nvidia-driver

echo "Installing NVIDIA drivers"
dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

echo "Waiting on akmods to finsh - this will take a bit
while $nv | grep 'ERROR';
    do
      for i in "${spin[@]}"
      do
        echo -ne "\b$i"
        sleep 0.1
  done
done



