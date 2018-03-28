#!/bin/bash

#Step 1) Check if root--------------------------------------
if [[ $EUID -ne 0 ]]; then
   echo "Please execute script as root." 
   exit 1
fi
#-----------------------------------------------------------

#Step 2) Remove Installation directory ---------------------

killse=killes.service
cd /opt/

sudo rm -r RetroFlag

cd /etc/systemd/system/
sudo systemctl disable killes
rm -r $killse

cd /boot/
File=config.txt

if grep -q "avoid_warnings=2" "$File";
        then
        	 sed -i '/avoid_warnings=2 \&/c\' "$File";
fi
if grep -q "avoid_warnings=1" "$File";
        then
                 sed -i '/avoid_warnings=1 \&/c\' "$File";
fi

#-----------------------------------------------------------

#Step 3) Remove configuration script ------------
cd /etc/
RC=rc.local

#Cleaning deprecated configration files --------------------
echo Cleaning configration files from rc.local
if grep -q "sudo python3 \/opt\/RetroFlag\/retroflag.py \&" "$RC";
        then
               sed -i '/sudo python3 \/opt\/RetroFlag\/retroflag.py \&/c\' "$RC";
fi

if grep -q "sudo python \/opt\/RetroFlag\/retroflag.py \&" "$RC";
        then
               sed -i '/sudo python \/opt\/RetroFlag\/retroflag.py \&/c\' "$RC";
fi

if grep -q "sudo python \/opt\/RetroFlag\/shutdown-retroflag.py \&" "$RC";
        then
               sed -i '/sudo python \/opt\/RetroFlag\/shutdown-retroflag.py \&/c\' "$RC";
fi

#-----------------------------------------------------------
#Step 4) Reboot to apply changes----------------------------
echo "Retroflag NESPi Front Panel Control Switch un-install complete. Will now reboot after 3 seconds."
sleep 4
sudo reboot
#-----------------------------------------------------------
