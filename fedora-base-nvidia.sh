!/bin/bash
# This script is to install the basics on a new Fedora box. 
# I am not responsible for if things break or it doesn't work.
# This script is not a substitue for not knowing what is going on.

# Set variables

fv=$(cat /etc/os-release | grep VERSION_ID | cut -d = -f2)
UPDATES=$(dnf check-update --quiet | grep -Ev 'Last metadata expiration|^$' | wc -l)
sb=$(mokutil --sb-state | grep disabled | wc -l)
nv=$(modinfo -F version nvidia | grep ERROR | wc -l)
spinner=('|' '/' '-' '\\')
delay=0.1
i=0

# Make sure script it running as root

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

# Check if SecureBoot is enabled
if [ "$sb" -lt 1 ]; then
    echo "SecureBoot is currently enabled"
    echo "This script does not support having SecureBoot enabled at this time"
    echo "Please disable SecureBoot before running it again"
    exit 1
else
    echo "SecureBoot is disabled."
    sleep 2
fi

# Update the system
echo "Checking for updates before continuing"
sleep 2

if [ "$UPDATES" -gt 0 ]; then
        echo "$UPDATES updates available. Applying updates..."
        sleep 2
    # Apply all available updates without prompting
        dnf update -y

        echo "You will need to reboot before continuing! Otherwise the NVIDIA drivers will not compile right"
        exit 1

else
        echo "No updates available. Let's keep going."
        sleep 2
fi

# Install the RPM fusion repos
echo "Installing RPM fusion free repos for Fedora $fv"
sleep 2
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$fv.noarch.rpm

echo "Installing RPM fusion non-free repos for Fedora $fv"
sleep 2
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fv.noarch.rpm

# Start the QOL stuff
echo "Swapping ffmpeg"
sleep 2
dnf swap -y ffmpeg-free ffmpeg --allowerasing

echo "Installing Multimedia codecs"
sleep 2
dnf install -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

echo "Installing VAAPI"
sleep 2
dnf install -y libva-nvidia-driver

echo "Installing NVIDIA drivers"
sleep 2
dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

# Wait on akmods to finish
while [ $nv -gt 0 ];do
        printf "\r[%s] Waiting on akmods to finish - this will take a bit" "${spinner[i]}"
        i=$(( (i + 1) % ${#spinner[@]} ))
        sleep "$delay"
done

echo "Done! You should be able to reboot and have a working system"
echo "Reminder: You can hit escape during boot to view what is going on."




