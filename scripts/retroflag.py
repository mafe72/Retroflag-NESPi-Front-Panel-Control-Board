#####################################
# RetroFlag NESPi Control Board Script
#####################################
# Hardware:
# Board by Eladio Martinez
# https://oshpark.com/shared_projects/ssSJDKKQ
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
#
# While playing a game:
#  Press RESET 
#    To reboot current game
#  Hold RESET for 3 seconds
#    To quit current game

import RPi.GPIO as GPIO
import time
import os
import socket
from gpiozero import Button, DigitalOutputDevice

resetButton = 2
powerButton = Button(3)
fan = DigitalOutputDevice(4)
hold = 2
rebootBtn = Button(resetButton, hold_time=hold)

GPIO.setmode(GPIO.BCM)
GPIO.setup(resetButton,GPIO.IN, pull_up_down=GPIO.PUD_UP)

#Get CPU Temperature
def getCPUtemp():
	res = os.popen('vcgencmd measure_temp').readline()
	return (res.replace("temp=","").replace("'C\n",""))
	
def retroPiCmd(message):
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	sock.sendto(message, ("127.0.0.1", 55355))

while True:
	#Power / LED Control
	#When power button is unlatched turn off LED and initiate shutdown
	if not powerButton.is_pressed:
		os.system("sudo shutdown -h now")
		
	#RESET Button pressed
	if rebootBtn.is_pressed:
		retroPiCmd("RESET")

	if rebootBtn.is_held:
		retroPiCmd("QUIT")

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
	time.sleep(0.50)
