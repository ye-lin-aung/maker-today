+++
title = "ublox NEO-6M - NMEA Parsing - Part 1"
date = "2017-10-08T23:28:00+08:00"
tags = ["gps"]
categories = ["hardware"]
banner = "img/banners/introduction-to-makers-today.png"
+++

## Introduction
---

The purpose of this guide is to clear up some misunderstandings and cement the knowledge I have around the use of the ublox NEO-6M GPS unit. The overall goal of this project is still a little up in the air, however I know that at some stage a firm understand of GPS systems and [NMEA](https://en.wikipedia.org/wiki/NMEA_0183) string parsing will be very useful.

### BOM
---

* 1x - [U-blox NEO-6M GPS Module](https://core-electronics.com.au/u-blox-neo-6m-gps-module.html) - $20.45
* 1x - [Nano CH340/ATmega328P](https://www.aliexpress.com/item/Nano-CH340-ATmega328P-MicroUSB-Compatible-for-Arduino-Nano-V3/32572612009.html) - $2.49

### Research
---

I would be lying if I said that when I began working on this project I jumped straight onto the ublox website and did a large amount of research on the exact specifications of the chip. This decision came back to bite me in lost time and I truly regret it. SO in hopes that you don't make the same mistake I made, here's the datasheet for the [NEO-6M](https://www.u-blox.com/sites/default/files/products/documents/NEO-6_DataSheet_(GPS.G6-HW-09005).pdf), and I'll follow that up with a summary of the imporant aspect of the chip itself.


### NEO-6M
---

#### Specifications

*Name:* NEO-6M

*Type:* NEO-6M-0-001

*ROM/FLASH:* version: ROM7.03

*PCN reference:* UBX-TN-11047-1

#### Protocol

*NMEA Input/output, ASCII, 0183, 2.3 (compatible to 3.0)*

The protocol we'll focus on for this guide is [NMEA 0183](https://en.wikipedia.org/wiki/NMEA_0183). This is the default configuration that the board I purchased runs on and is the industry standard.

#### Message Format

*Message:* GSV, RMC, GSA, GGA, GLL, VTG, TXT

*UARTBaud rate:* 9600


#### Output

```bash
Status,UTC Date/Time,Lat,Lon,Hdg,Spd,Alt,Sats,Rx ok,Rx err,Rx chars,
3,2017-10-08 17:18:44.000,-319938697,1159107792,,84,,,1,0,66,
3,2017-10-08 17:18:45.000,-319938703,1159107782,,103,1230,5,10,0,588,
3,2017-10-08 17:18:46.000,-319938710,1159107778,,63,1220,5,19,0,1110,
3,2017-10-08 17:18:47.000,-319938703,1159107787,,128,1220,5,28,0,1632,
3,2017-10-08 17:18:48.000,-319938690,1159107795,,92,1220,5,37,0,2154,
3,2017-10-08 17:18:49.000,-319938683,1159107795,,49,1220,5,46,0,2676,
3,2017-10-08 17:18:50.000,-319938678,1159107797,,83,1210,5,55,0,3198,
3,2017-10-08 17:18:51.000,-319938687,1159107788,,49,1210,5,64,0,3720,
3,2017-10-08 17:18:52.000,-319938700,1159107773,,37,1200,5,73,0,4242,
3,2017-10-08 17:18:53.000,-319938702,1159107765,,138,1190,5,82,0,4764,
3,2017-10-08 17:18:54.000,-319938698,1159107768,,26,1180,5,91,0,5286,
3,2017-10-08 17:18:55.000,-319938692,1159107778,,48,1170,5,100,0,5808,
3,2017-10-08 17:18:56.000,-319938700,1159107777,,88,1180,5,109,0,6330,
3,2017-10-08 17:18:57.000,-319938702,1159107788,,67,1180,5,118,0,6852,
3,2017-10-08 17:18:58.000,-319938697,1159107790,,88,1190,5,127,0,7374,
3,2017-10-08 17:18:59.000,-319938683,1159107800,,56,1180,5,136,0,7896,
3,2017-10-08 17:19:00.000,-319938682,1159107808,,68,1180,5,145,0,8418,
3,2017-10-08 17:19:01.000,-319938683,1159107812,,87,1190,5,154,0,8940
```

### PlatformIO
---

I've recently begun using [PlatformIO](http://docs.platformio.org/en/latest/ide.html#platformio-ide) as my *goto* method for developing for embedded systems, and this project had me stumped for a few hours whilst I was trying to get the [NeoGPS](https://github.com/SlashDevin/NeoGPS) and [AltSoftSerial](https://github.com/PaulStoffregen/AltSoftSerial) libraries playing nicely with one another.

I plan to go into more detail on the usage of PlatformIO in the future, however for the sake of time there's only really two things you need to ensure are present in the project file(s).

* **platformio.ini** - ensure that the libraries we need [NeoGPS](https://github.com/SlashDevin/NeoGPS) and [AltSoftSerial](https://github.com/PaulStoffregen/AltSoftSerial) are present and defined under the board environment type.

```ini
[env:nanoatmega328]
platform = atmelavr
board = nanoatmega328
framework = arduino
lib_deps = NeoGPS, AltSoftSerial
```

* **src/main.cpp** - Ensure that the libraries are referenced correctly and use the local ``lib`` instance of the libraries

```cpp
#include <Arduino.h>
#include <NMEAGPS.h>
#include <GPSport.h>
```

### References

[gps-neo6-nano Repo](https://github.com/t04glovern/gps-neo6-nano)

[ublox NEO-6 Datasheet](https://www.u-blox.com/sites/default/files/products/documents/NEO-6_DataSheet_(GPS.G6-HW-09005).pdf)