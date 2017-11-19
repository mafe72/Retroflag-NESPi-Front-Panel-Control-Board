Retroflag NESPi Front Panel Control Board
===============================

Features
--------

* Safe shutdown Pi from power switch

* Reboot Pi from reset switch

* 2 wire fan control


 BOM can be ordered from mouser:
https://www.mouser.com/ProjectManager/ProjectDetail.aspx…

PCB can be ordered from oshpark:
https://oshpark.com/shared_projects/V2yqoyFn


Bottom Side:
![](RetroflagNESPi-TH_Back.png)

Top Side
![](RetroflagNESPi-TH_Front.png)


Software Installation
---------------------
 1. Transfer the retroflag.py file to the Raspberry Pi in folder: 

        ~/home/pi/RetroFlag/retroflag.py

 2. Update rc.local:

        sudo nano /etc/rc.local

 3. Add the following just before the line "exit 0":

        (sleep 1; python /home/pi/RetroFlag/retroflag.py)&
		
Hardware Installation
---------------------

  * `RST Pin` - Connect to GPIO 2 (RPI pin 3)
  * `PWR Pin` - Connect to GPIO 3 (RPI pin 5)
  * `FAN_CT Pin` - Connect to GPIO 4 (RPI pin 7)
  * `OUT + Pin` - Connect to 5V (RPI pin 4)
  * `OUT - Pin` - Connect to GND (RPI pin 6)
  * `- IN + Pin` - Source 5v