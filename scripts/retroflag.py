#####################################
# RetroFlag NESPi Control Board Script
#####################################
# Hardware:
# Board by Eladio Martinez
# https://oshpark.com/shared_projects/V2yqoyFn
#
# BOM
# https://www.mouser.com/ProjectManager/ProjectDetail.aspx?AccessID=31b58a360e
#
#####################################
# Wiring:
#  GPIO 2  Reset Button (INPUT)
#  GPIO 3  Power Button (INPUT)
#  GPIO 4  Fan on signal (OUTPUT)
#
#####################################
#  Required python libraries
#  sudo apt-get update
#  sudo apt-get install python-dev python-pip python-gpiozero
#  sudo pip install psutil pyserial
#
#####################################
# Basic Usage:
#  POWER ON
#    While powered off
#    Press (LATCH) POWER button
#    Wait for Raspberry Pi to boot
#  POWER OFF
#    While powered on
#    Press (Unlatch) POWER button
#    Wait for Raspberry Pi to shutdown
#  RESET
#    Hold RESET button to reboot Pi


import os 
import time
import socket
from gpiozero import Button, DigitalOutputDevice

resetButton = Button(2)  #Connect RST Pin to GPIO 2 (RPI pin 3)

powerButton = Button(3)  #Connect PWR Pin to GPIO 3 (RPI pin 5)

fan = DigitalOutputDevice(4)  #Connect FAN_CT to GPIO 4 (RPI pin 7)

#Get CPU Temperature
def getCPUtemp():
	res = os.popen('vcgencmd measure_temp').readline()
	return (res.replace("temp=","").replace("'C\n",""))

#Main worker loop
while True:
	#Power / LED Control
	#When power button is unlatched turn off LED and initiate shutdown
	if not powerButton.is_pressed:
		os.system("sudo shutdown -h now")

	#RESET Button
	if resetButton.is_pressed:
		os.system("sudo reboot")
	
	#Fan control
	#Adjust MIN and MAX TEMP as needed to keep the FAN from kicking
	#on and off with only a one second loop
	cpuTemp = int(float(getCPUtemp()))
	fanOnTemp = 55  #Turn on fan when exceeded
	fanOffTemp = 40  #Turn off fan when under
	if cpuTemp >= fanOnTemp:
		fan.on()
	if cpuTemp < fanOffTemp:
		fan.off()
		
	time.sleep(1)