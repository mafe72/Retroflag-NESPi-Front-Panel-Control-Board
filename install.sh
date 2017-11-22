#!/bin/bash


#Step 1) Check if root--------------------------------------
if [[ $EUID -ne 0 ]]; then
   echo "Please execute script as root." 
   exit 1
fi
#-----------------------------------------------------------

#Step 2) enable UART----------------------------------------
cd /boot/
File=config.txt
if grep -q "enable_uart=1" "$File";
	then
		echo "UART already enabled. Doing nothing."
	else
		echo "enable_uart=1" >> $File
		echo "UART enabled."
fi
#-----------------------------------------------------------

#Step 3) Update repository----------------------------------
sudo apt-get update -y
#-----------------------------------------------------------

#Step 4) Install gpiozero module----------------------------
sudo apt-get install -y python3-gpiozero
sudo pip install psutil pyserial
#-----------------------------------------------------------

#Step 5) Download Python script-----------------------------
cd /opt/
sudo mkdir RetroFlag
cd /opt/RetroFlag
script=retroflag.py

if [ -e $script ];
	then
		echo "Script retroflag.py already exists. Doing nothing."
	else
		wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/retroflag.py"
fi
#-----------------------------------------------------------

#Step 6) Enable Python script to run on start up------------
cd /etc/
RC=rc.local

if grep -q "sudo python3 \/opt\/RetroFlag\/retroflag.py \&" "$RC";
	then
		echo "File /etc/rc.local already configured. Doing nothing."
	else
		sed -i -e "s/^exit 0/sudo python3 \/opt\/RetroFlag\/retroflag.py \&\n&/g" "$RC"
		echo "File /etc/rc.local configured."
fi
#-----------------------------------------------------------

#Step 7) Reboot to apply changes----------------------------
echo "Retroflag NESPi Front Panel Control Switch installation done. Will now reboot after 3 seconds."
sleep 3
sudo reboot
#-----------------------------------------------------------
