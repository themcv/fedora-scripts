#!/bin/bash
# This script is to install the basics on a new Fedora box. 
# I am not responsible for if things break or it doesn't work.
# This script is not a substitue for not knowing what is going on.

# Set variables

fv=$(cat /etc/os-release | grep VERSION_ID | cut -d = -f2)
UPDATES=$(dnf check-update --quiet | grep -Ev 'Last metadata expiration|^$' | wc -l)

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


# Install the RPM fusion repos and epel
echo "Installing RPM fusion free repos for Fedora $fv"
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$fv.noarch.rpm

echo "Installing RPM fusion non-free repos for Fedora $fv
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fv.noarch.rpm

echo "Swapping ffmpeg"
dnf swap ffmpeg-free ffmpeg --allowerasing

echo "Installing Multimedia codecs"
dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin




