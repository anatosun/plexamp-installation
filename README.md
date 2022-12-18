# Plexamp installation 

This set of instructions is supposed to help you install Plexamp on a totally headless system. The steps below and the script have been tested on Raspberry Pi Zero 2W without any issue. Feel free to submit pull requests if you notice anything is unclear or missing.


## Flashing SD Card

These steps should help you flash Raspberry Pi Os Lite onto a SD card.

1. Download [Raspberry Pi Os Lite](https://www.raspberrypi.com/software/operating-systems/) for 64-bit systems.
2. Insert your SD card into your computer.
3. Install and run [balena Etcher](https://www.balena.io/etcher/), select the image downloaded at step 1 and the SD card inserted at step 2, press **Flash**.
4. Once the flashing process has concluded, mount the `boot` partition of the SD card.
5. Create a blank `ssh` file in the boot partition so that `ssh` is activated directly.
6. Still in the boot partition, create a file `userconf.txt` that contains the following line `pi:$6$VK61vudeQ.k2op9s$ahMaom/fCgj/YzwsBDZDd21W3RdarHFpUVIHEW3JalCHxxxyWfRjzV0shzPtrB4PPKO5MzYQr754NmUHvbU8r0`. This will create user `pi` with password `1234` on the first boot.
7. One last file to add to the boot partition is a one called `wpa_supplicant.conf` that contains your wifi SSID and password. An example file is showcased below.
```conf
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  ssid="YOUR_WIFI_SSID"
  scan_ssid=1
  psk="YOUR_WIFI_PASSWORD"
  key_mgmt=WPA-PSK
}
```
8. Once done, unmount your SD card, insert it into your Pi and plug your Pi to its power supply.


## Connecting to your Pi

1. Acknowledge your Pi's IP address either by pinging your pi `ping raspberrypi` or by reading it from your router graphical interface.
2. ssh into it with `ssh pi@<ip-address>` and enter the password `1234`
3. Change the password by typing `passwd`.
4. Update your system with `sudo apt update && sudo apt upgrade -y`

## Installing Plexamp

Run this command to install Plexamp and different dependencies. Follow the on-screen instructions.

```bash
curl https://raw.githubusercontent.com/fwicht/plexamp-install/main/install.sh | bash 
```
