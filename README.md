# esp32_tasmota_rotex_solaris_moitor

This small project makes it possible to monitor the Rotex Solaris system with an ESP32 development board.
Sensor data will be displayed directly on tasmota devices website and published via MQTT (e.g. for use in home assistant)


# What you need
- 3,5 Stereo Jack
- ESP32 development board
- 5V to 3,3V level shifter
- some jumper wires
- Power supply for your ESP32 development board


# Setup steps
## Flash tasmota to your ESP32 development board. I used the M5Stack Atom lite.


## Prepare 3,5 jack
The 3,5 jack is used to connect Solaris control unit with the ESP32.

  |Solaris RPS3|Description   |ESP32  |Note|
  |------------|--------------|-------|-------|
  |TIP         | RPS3 TX      |GPIO16 |Left channel|
  |RING        | RPS3 RX      |Not neccesary|Right channel|
  |SLEEVE      | GND          |GND    |Ground|

Connected cables at 3,5 jack

<img width="473" alt="lower shifter voltage" src="https://github.com/BitSWB/esp32_tasmota_rotex_solaris_moitor/blob/main/docs/assets/images/3.5_jack.jpg">
 
 
Connected cables to 3,5 jack and level shifter

<img width="473" alt="lower shifter voltage" src="https://github.com/BitSWB/esp32_tasmota_rotex_solaris_moitor/blob/main/docs/assets/images/3.5_jack_with_level_shifter.jpg">

## Configure Rotex Solaris to output data at the serial port
It is necesary activate Serial Comunication in RPS3 module. 
You must enter the code of technical user, (default is 0110).
Choose the following options.

  |Solaris RPS3|Description   |
  |------------|--------------|
  |cicle /s    | 15s          |
  |expedient   | AD-232       |      
  |baudrate    | 19200        |
  |direction   | 255          |


## install solaris_driver
Upload the solaris_driver.be to the root of your ESP32
Adjust the file unomment the english translation part and comment the german part if you prefer english instead of german.
Adjust self.rx_pin = 25 if you connect to ohter gpio than 25.

## autorun.be
Add the following line to autorun.be (create file if it is not available)

load("solaris_driver.be")


# Usage examples
## Tasmota site
<img width="473" alt="lower shifter voltage" src="https://github.com/BitSWB/esp32_tasmota_rotex_solaris_moitor/blob/main/docs/assets/images/tasmota.jpg">

## Home assistant
See configuration.yaml in repo for configuration example.
For image element configuration see image_configuration.yaml

<img width="473" alt="lower shifter voltage" src="https://github.com/BitSWB/esp32_tasmota_rotex_solaris_moitor/blob/main/docs/assets/images/homeassistant.jpg">


# Known Problems
- A bad power supply for ESP32 can cause the flow sensor to report incorrect values
