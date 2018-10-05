#####################################
# RetroFlag NESPi Control Board Script
#####################################
# Hardware:
# Board by Eladio Martinez
# http://mini-mods.com
#
#####################################
# Wiring:
#  GPIO 2  Reset Button (INPUT)
#  GPIO 3  Power Button (INPUT)
#  GPIO 4  Fan on signal (OUTPUT)
#  GPIO 14 LED on signal (OUTPUT)
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
#	 LED will turn ON
#    Wait for Raspberry Pi to boot
#  POWER OFF
#    While powered on
#    Press (Unlatch) POWER button
#	 LED will turn OFF
#    Wait for Raspberry Pi to shutdown
#
# While playing a game:
#  Press RESET 
#    To reboot current game
#	 No change on LED status
#  Hold RESET for 3 seconds
#    To quit current game
#	 LED will BLINK

import RPi.GPIO as GPIO
import time
import os
import socket
from gpiozero import Button, LED
GPIO.setmode(GPIO.BCM)

resetButton = 2
powerButton = Button(3)

GPIO.setup(4, GPIO.OUT)
fan = GPIO.PWM(4, 50) #PWM frequency set to 50Hz

led = LED(14)
hold = 2

rebootBtn = Button(resetButton, hold_time=hold)
GPIO.setup(resetButton,GPIO.IN, pull_up_down=GPIO.PUD_UP)

#Get CPU Temperature
def getCPUtemp():
	res = os.popen('vcgencmd measure_temp').readline()
	return (res.replace("temp=","").replace("'C\n",""))
	
while True:
	#Power / LED Control
	#When power button is unlatched turn off LED and initiate shutdown
	if not powerButton.is_pressed:
		print ("Gracefully finishing EmulationStation...")
		os.system("/bin/bash /opt/RetroFlag/killes.sh")
                os.system("omxplayer -o hdmi /opt/RetroFlag/tone.mp3")
		print ("Shutting down...")
		os.system("shutdown -h now")
		break
	else:
		led.on()  #Take control of LED instead of relying on TX pin
		
	#RESET Button pressed
	#When Reset button is presed restart EmulationStation
	if rebootBtn.is_pressed:
		os.system("systemctl restart autologin@tty1.service")

	#RESET Button held
	#When Reset button is held for more then 3 sec reboot Console
	if rebootBtn.is_held:
		led.blink(.2,.2)
		os.system("reboot")

	#Fan control
	#Adjust MIN and MAX TEMP as needed to keep the FAN from kicking
	#on and off with only a one second loop
	cpuTemp = int(float(getCPUtemp()))
	fanOnTemp = 55  #Turn on fan when exceeded
	fanOffTemp = 40  #Turn off fan when under
	if cpuTemp >= fanOnTemp:
		fan.start(90) #90% duty cycle
	if cpuTemp < fanOffTemp:
		fan.stop()
	time.sleep(1.00)
