# fedora-scripts
A (soon to be) collection of a few handy scripts that cover the basics for a new Fedora installation

## What this script does
- Makes sure your system is up to date
- Installs free and non-free RPMFusion repositories
- Installs the full ffmpeg
- Installs the Multimedia group codecs
- Installs VAAPI for NVENC
- Installs NVIDIA drivers

## Using the scripts

- Download the script you would like to use
- Once downloaded, open a terminal and run the following:
```
cd ~/Downloads
chmod +x fedora-base-nvidia.sh
./fedora-base-nvidia.sh
```
## Caveats
This script requires the following:
- You must run it as root
- You must have SecureBoot disabled

## Final word
I plan to add in other tidbits as I think of them. You are free to open an issue for any suggestions for scripts for newcomers!
