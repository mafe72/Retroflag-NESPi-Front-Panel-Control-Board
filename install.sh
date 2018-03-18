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
		echo "enable_uart=1" >> "$File"
		echo "UART enabled."
fi
# Enable additional settings-------------------------------
if grep -q "hdmi_drive=2" "$File";
	then
		echo "HDMI Sound already enabled. Doing nothing."
	else
		echo "hdmi_drive=2" >> "$File"
		echo "HDMI Sound enabled."
fi
if grep -q "disable_splash=1" "$File";
	then
		echo "splash screen already disable. Doing nothing."
	else
		echo "disable_splash=1" >> "$File"
		echo "splash screen disable."
fi
if grep -q "avoid_warnings=0" "$File";
        then
                sed -i '/avoid_warnings=0/d' "$File";
fi
if grep -q "avoid_warnings=1" "$File";
        then
                echo "warnings already disable. Doing nothing."
        else
                echo "avoid_warnings=1" >> "$File"
                echo "warnings disable."
fi
#-----------------------------------------------------------

#Step 3) Update repository----------------------------------
sudo apt-get update -y
#-----------------------------------------------------------

#Step 4) Install gpiozero module----------------------------
sudo apt-get install -y python-dev python-pip python-gpiozero
sudo pip install psutil pyserial
sudo apt-get install wiringpi
#-----------------------------------------------------------

##Remove downloaded package files in order to free up space-
echo Remove downloaded package files
sudo apt-get clean
#-----------------------------------------------------------

#Step 5) Download Python script-----------------------------
cd /opt/
sudo mkdir RetroFlag
cd /opt/RetroFlag
oldscript=retroflag.py
script=shutdown-retroflag.py
tone=tone.mp3
killes=killes.sh
killse=killes.service

if [ -e $script ];
        then
                echo "Deleting old retroflag.py script..."
                rm -r $oldscript
                rm -r $tone
fi

if [ -e $script ];
	then
		echo "Script shutdown-retroflag.py already exists. Updating..."
                rm -r $script
		rm -r $tone
		rm -r $killes
		wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/shutdown-retroflag.py"
		wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/tone.mp3"
                wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/killes.sh"
		chmod a+x killes.sh
		echo "Updating Kill ES Service...."
		cd /etc/systemd/system/
		sudo systemctl disable killes
		rm -r $killse
		wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/killes.service"
		sudo systemctl enable killes
		echo "Update complete."
	else
		wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/shutdown-retroflag.py"
                wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/tone.mp3"
                wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/killes.sh"
                chmod a+x killes.sh
		echo "Updating Kill ES Service...."
                cd /etc/systemd/system/
                wget "https://raw.githubusercontent.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/master/scripts/killes.service"
		sudo systemctl enable killes
		echo "Download complete."
fi
#-----------------------------------------------------------

#Step 6) Enable Python script to run on start up------------
cd /etc/
RC=rc.local

#Cleaning deprecated configration files --------------------
echo Cleaning deprecated configration files from rc.local
if grep -q "sudo python3 \/opt\/RetroFlag\/retroflag.py \&" "$RC";
        then
               sed -i '/sudo python3 \/opt\/RetroFlag\/retroflag.py \&/c\' "$RC";
fi

if grep -q "sudo python \/opt\/RetroFlag\/retroflag.py \&" "$RC";
        then
               sed -i '/sudo python \/opt\/RetroFlag\/retroflag.py \&/c\' "$RC";
fi

#Adding new configuration-----------------------------------
echo Adding new configuration files to rc.local 
if grep -q "sudo python \/opt\/RetroFlag\/shutdown-retroflag.py \&" "$RC";
	then
		echo "File /etc/rc.local already configured. Doing nothing."
	else
		sed -i -e "s/^exit 0/sudo python \/opt\/RetroFlag\/shutdown-retroflag.py \&\n&/g" "$RC"
		echo "File /etc/rc.local configured."
fi
#-----------------------------------------------------------
#Step 8) Setup retroarch settings---------------------------
cd /opt/retropie/configs/all/
rac=retroarch.cfg
if grep -q 'config_save_on_exit = "true"' "$rac";
	then
		echo "save on exit alredy enabled. Doing nothing."
	else
		sed -i '/config_save_on_exit = "false"/c\config_save_on_exit = "true"' "$rac"
		echo "save on exit enabled."
fi
if grep -q 'network_cmd_enable = "true"' "$rac";
	then
		echo "network cmd alredy enabled. Doing nothing."
	else
		sed -i '/network_cmd_enable = "false"/c\network_cmd_enable = "true"' "$rac"
		echo "network cmd enabled."
fi
if grep -q 'network_cmd_port = "55355"' "$rac";
	then
                echo "network port 55355 alredy enabled. Doing nothing."
        else
		sed -i '/network_cmd_port = "55355"/c\network_cmd_port = "55355"' "$rac"
		echo "network port 55355 enabled."
fi
#-----------------------------------------------------------
#Step 9) Reboot to apply changes----------------------------
echo "Retroflag NESPi Front Panel Control Switch installation done. Will now reboot after 3 seconds."
sleep 4
sudo reboot
#-----------------------------------------------------------
