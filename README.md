Retroflag NESPi Front Panel Control Board
===============================
This is an enhancement board for the RetroFlag NESPi case, this PCB add missing functionality to the system.


License
-------
<div align="center"><a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Attribution-NonCommercial-ShareAlike" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /></div>

This project is licensed under the Attribution-NonCommercial-ShareAlike CC BY-NC-SA 4.0 license. The full legal text of the license may be found in the LICENSE.txt file in this repository. For more information about this license, please visit 
the Creative Commons Foundation (https://creativecommons.org/licenses/by-nc-sa/4.0/).

Features
--------

* Soft-shutdown Pi from power switch

* Reboot Pi from reset switch

* 2 wire fan control

----------
Bottom Side:
![CBottom Side](pictures/RetroflagNESPi-TH_Back.png)

Top Side
![Top Side](pictures/RetroflagNESPi-TH_Front.png)

Power Board
![Power Board](pictures/RetroflagNESPi-Power-SMD.png)

----------

Bill of Materials
-----------------

[Mouser shared BOM here](https://www.mouser.com/ProjectManager/ProjectDetail.aspx?AccessID=31b58a360e)


Fabrication
-----------

[OSHPark shared project here](https://oshpark.com/shared_projects/6rl8VzXl)

Prerequisites
---------------------

1. RetroPie

      To install Retropie you may download the image for [Raspberry Pi 3](https://github.com/RetroPie/RetroPie-Setup/releases/download/4.2/retropie-4.2-rpi2_rpi3.img.gz "RetroPie for version RPi 2/3") and follow installation instruction at the [retropie website](https://retropie.org.uk/docs/First-Installation/#installation "RetroPie installation instructions").

2. Internet connection

      Internet access via Ethernet or to set up your internet via WiFi, you can follow the instructions [here](https://retropie.org.uk/docs/Wifi/ "RetroPie WiFi Setup").

3. Keyboard and screen, or any computer/laptop (via SSH)

      To access your Pi via SSH, you can also follow this instructions [here](https://retropie.org.uk/docs/SSH/ "Raspberry Pi SSH Setup").


Hardware Installation
---------------------
It's very important to follow the right pin configuration to prevent damage to your Pi.

  * `RST Pin` - Connect to GPIO 2 (RPI pin 3)
  * `PWR Pin` - Connect to GPIO 3 (RPI pin 5)
  * `FAN_CT Pin` - Connect to GPIO 4 (RPI pin 7)
  * `OUT + Pin` - Connect to 5V (RPI pin 4)
  * `OUT - Pin` - Connect to GND (RPI pin 6)
  * `- IN + Pin` - Source 5v

Software Installation
---------------------

**NOTE**: This assumes that you have already connected the jumper wires to the correct PINS and ports;
If you haven't, see the [Hardware Installation](#hardware-installation) section.

This instructions are a *step-by-step guide* to install necessary software for your **Retroflag NESPi Front Panel Control Board**.
You can setup this via SSH or using the command line interface in your RetroPie. To enter the command line interface of RetroPie, *PRESS* ***F4*** just after booting up.

----------

Open your terminal and type the one-line installation command below:
```bash
$ wget -O - "https://github.com/mafe72/Retroflag-NESPi-Front-Panel-Control-Board/raw/master/install.sh" | sudo bash
```

The script will automatically install pertinent files and configure your Raspberry Pi to enable **Retroflag NESPi Front Panel Control Board.**
Installation will automatically reboot once all processes are completed.

After rebooting, your **Retroflag NESPi Front Panel Control Board** is now fully functional.

----------
	
Basic Usage
-----------

* POWER ON
			
		While powered off
			Press (LATCH) POWER button
			Wait for Raspberry Pi to boot		
* POWER OFF
		
		While powered on
			Press (Unlatch) POWER button
			Wait for Raspberry Pi to shutdown			
* RESET
		
		Hold RESET button to reboot Pi
	