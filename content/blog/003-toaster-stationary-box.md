+++
title = "Toaster Stationary Box"
date = "2017-12-17T21:24:00+08:00"
tags = ["toaster", "stationary"]
categories = ["DIY"]
banner = "img/blog/2017/12/toaster-box-icon.png"
+++

## Introduction
---

We recently visited [Spotlight](https://www.spotlightstores.com), a local craft & knick-knack store in search of a DIY stationary kit that would be assembled and built into a christmas gift for some close friends.

After spending a while searching we came across a `DIY` kit the just required assembly.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/stationary-kit-spotlight.jpg" />

The kit was ok, and it would have done the job, however the price was a little much for what was effectively just some laser cut MDF.

We were just about to concede and spend the money when I noticed something out of the corner of my eye. It was **sleek**, **white** and **curved** in all the right places.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-spotlight.jpg" />

I knew when I saw it that it was perfect, half the price as well meaning I had an extra ten dollary-doos to spend on decorations.

### BOM
---

* 1x - [IMK 2 Slice Toaster](https://www.spotlightstores.com/kitchen-dining/kitchen-appliances/toasters/imk-2-slice-toaster/p/BP80271373) : $9.95
* 1x - [Nano CH340/ATmega328P](https://www.aliexpress.com/item/Nano-CH340-ATmega328P-MicroUSB-Compatible-for-Arduino-Nano-V3/32572612009.html) : $2.49
* 16x - Red, Blue, Green, Yellow LEDs

### Toaster Teardown
---

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-pop-feature.gif" />

The toaster itself was pretty simple in design. Running off 240V it had a small stepdown circuit which doubled as the circuit board for the toast timer and ejector button.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-teardown-circuit.jpg" />

#### Electromagnet
---

This **94V** component is the mechanism that holds the bread-bays down when the toaster is operational. As shown below, when the bays are lowered the metal pad on the base of the plastic handle clicks into place between two copper pads.

Both the copper pads are pushed into the pads on the outside, activating the toaster circuit. When the circuit goes active the electromagnet grips the spring-loaded mechanism and holds it in place.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-spring-demo.gif" />

#### Potentiometer
---

The potentiometer is very standard, it serves as a control mechanism for the length of time you want to toast the bread for. As the potentiometer is twisted, the amount of resistance in the timer circuit is increased.

A capacitor charges through a resistor, and when it reaches a certain voltage it cuts off the power to the electromagnet. The spring immediately pulls the two slices of bread up.

Changing the resistance changes the rate at which the capacitor charges, and this controls how long the timer waits before releasing the electromagnet.

#### Press switch
---

The switch button provides a method of quickly discharging the capacitors in the toasting circuit which has the effect of releasing the magnetic mechanism at any point during the toast.

### Toastuino
---

The only thing I knew I wanted for sure going into this project was **Lots of LEDs**. So I set to work on adding 16 around the center of one panel on the toaster.

#### LED Hell
---

Something I knew but chose to ignore about LEDs early on is that they have different **forward bias voltage** requirements.

When the forward bias voltage becomes large enough, excess electrons from one side of the junction (diode) start to combine with holes from the other side. When this occurs, the electrons fall into a less energetic state and release energy. In LEDs this energy is released in the form of photons.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-led-roygbuiw.png" />

The materials from which the LED is made determine the wavelength, and therefore the color of the emitted light.

I made three mistakes:

* **LEDs use voltage** - Initially I setup my 16 LEDs in series and completely blanked on the fact that there would be a voltage drop equal to the forward bias voltage at each LED in the chain. This meant that when testing I would have 2-3 LEDs light up before the chain would just not work.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-led-series.jpg" />

* **LEDs use current** - I next attempted to place each of my LEDs in parallel, laying out a 5V line and ground line in the center. This design also didn't make it too far as I realised pretty quickly that the drop in current was far too great to power each of the LEDs in this configuration. It also clicked that I wouldn't have any control over which LEDs lit up and which ones didn't, and I decided to go back to the drawing board and redesign this to allow for better control over the LEDs.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-led-parallel.jpg" />

* **Blue LEDs suck (voltage)** - As expressed in the ROYGBUIW LED diagram above, Blue LEDs require upwards of around 3.3-4.1V to operate. This meant that when I eventually chained 8 groups of LEDs, with two LEDs per group; the groups with blue LEDs in them, and esspecially if they were first in order would drain almost all the voltage leaving very little for the next LED in the series. I didn't really get around this problem, and simply replaced/changed the order of the blue LEDs in the groups.

The final design, that uses 8 groups of 2 LEDs in series can be seen below.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-led-series-groups.jpg" />

Each of these 8 groups has a **220 ohm** resistor on its Voltage in line. These lines are run off to the side with the intent being to hook them up to an Arduino to control.

#### LED Code
---

I've setup a repo to house the code for this project here: [https://github.com/t04glovern/toastuino](https://github.com/t04glovern/toastuino).

The logic is extremely simple, it simply cycles through digital pins 4-11 and adjusts the speed that the LEDs cycle at using the variable resistance value from the potentiometer on the unit.

```cpp
#include <Arduino.h>

const byte pinCount = 8;
const byte ledPins[pinCount] = {4, 5, 6, 7, 8, 9, 10, 11};

const int buttonPin = 3;
const int speedPin = 2;

int lightSpeed = 1; // Value * 100 = delay

int led = 1;

int prevUp = HIGH;

void setup()
{
    pinMode(buttonPin, INPUT);
} // end of setup

void turnOnLED(const byte which, const byte brightness)
{
    for (byte i = 0; i < pinCount; i++)
        analogWrite(ledPins[i], 0);

    if (which > 1)
        analogWrite(ledPins[which - 2], brightness); // make "which" zero-relative
} // end of turnOnLED

void loop()
{
    if (led > pinCount + 1)
        led = 1;

    turnOnLED(led++, 255);

    int sensorValue = analogRead(A0);
    lightSpeed = map(sensorValue, 0, 1024, 8, 1);
    delay(lightSpeed * 100);

} // end of loop
```

The potentiometer and switch button were just tapped onto from the toasters original PCB

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-potentiometer.jpg" />

This code and the LEDs from the previous step worked flawlessly-ish. There's a couple tweaked I wanted to make, but for now I was happy with it and wanted to close the box up.

I removed the old power cable from the hole in the base and replaced it with a simple USB data cable to power the unit and also allow me to flash the Arduino firmware whenever I needed to.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-usb-connector.jpg" />

### Decoration
---

For the decorations I decided I wanted to parts; Paint and 3D printed objects!

#### 3D Printed Snowflakes
---

Pretty self explanatory, I recently picked up a [Creality CR-10 3D Printer](https://www.banggood.com/DIY-Creality-CR-10-3D-Printer-300300400mm-Printing-Size-1_75mm-0_4mm-Nozzle-p-1085645.html) from [Banggood](https://www.banggood.com/) and I've been looking for excuses to use it.

I found these nice little snowflakes on [Thingiverse](https://www.thingiverse.com/thing:1958298) and decided they'd probably make a nice little addition (given the LEDs didn't end up taking as much space).

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/snowflake-3d-print-normal.jpg" />

I set these to the side, as I would need to deal with painting the unit before I could get too carried away with attaching random stuff to the frame.

#### Painting a Toaster
---

I'd picked out two colours for the toaster:

* Pyrrole Red
* Australian Sap Green

These were acrylic paints which I'd kinda just guessed would work okay on the plastic body of the toaster. I'd based this thought on my comparison between acrylic vs water colour paint... I'll get into this decision a little later

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-00.jpg" />

I began painting the toasters white plastic frame up to the point where I needed to cover the LEDs so i didn't cover them in the green slop. I just used some of the tape I had lying around from my 3D printer and continued without too much thought.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-01.jpg" />

For the base of the toaster I mixed some of my red and green to create a brownish red, which I kinda prefered over the raw red, and kinda regret not painting the red parts this new colour instead.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-02.jpg" />

The red kinda looked a little different from every angle, which was interesting; still not too sure how I feel about it.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-03.jpg" />

I also cleanly closed the white strip by hot gluing a star themed strap around the middle of the toaster.

It was at this point where I ran into an annoying problem. As I began peeling off the tape on the LED, the acrylic paint stretched with the tape and tore in a number of places.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-04.jpg" />

It was a nuisance however I mostly fixed up the holes in the paint by using a thin brush and some steady hand strokes.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-painting-05.jpg" />

At this point I needed to let the acrylic dry overnight to strengthen.

### Toastuino Talks
---

Being a christmas toaster I wanted it to be as festive as possible.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-festive-define.png" />

Festive defined a number of synonyms that my toaster would have to invoke. The two that stood out for me were `hilarious` and `merry`. I was also handling the rest fairly well with the LEDs and paints, however it was lacking a certain audible joyfulness that I wasn't going to leave unhandled.

<iframe class="img-responsive image-box-shadow" width="560" height="315" src="https://www.youtube.com/embed/tI0o4WwpXTY" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

I found this video and knew it was perfect! The plan was to have the toaster SING! or the very least speak...

#### Audio Playback on an ATmega328
---

The process of playing audio from a real-time operating system is completely different the playing a clip from a single chip micro-controller. This is especially the case when you are also trying to replay LED transitions at the same time.

The other complexity is around how I was going to hook up a speaker to the Arduino whilst minimizing the pin usages and circuit complexity (especially now that I've already got all the components fitted in place with hot-snot.

The answer to my worries came in the form of a fantastic blog post on [High-Low Tech](http://highlowtech.org/?p=1963) that explained and demonstrated how I could use PWM duty cycles over 1-wire to play audio.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-speaker-connections.jpg" />

There are two caveats:

1. **No SD Card**

    Means we are limited to the program memory for the audio clip (32kb).

2. **Quiet Audio**

    As I don't have an amplifier circuit, I can only produce a quiet output due to the voltage limitations from the PWM pin output.

More details on how the Audio code works is available on [Toastuino (Audio Encoding) repo](https://github.com/t04glovern/toastuino#audio-encoding) however I'll briefly outline the steps I took to prep and load the audio.

1. Youtube -> MP3
2. MP3 cut down to 1.5 seconds (Audacity)
3. MP3 Converted and output at a sample rate of 8Khz and a bit rate of 16Khz (iTunes).
4. Down sampled Audio converted to numeric values (EncodeAudio.exe).

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-speaker-code.jpg" />

The resulting numeric output, whilst not pretty does do the job fairly well, and it means I can accomplish audio clip replay over 1 PWM wire.

### Stationary Slots
---

The final piece of the box was a couple slots for the stationary to sit in. I realised this was a requirement after dropping a pen inside the box and having it get lodged in the metal grills.

This was also an excellent opportunity for me to get my hands dirty on CAD design!

I started measuring out the slot sizes, when I was quickly alerted to the fact that `I was doing it wrong` by Stephen, and that I should be sketching my designs out on paper if I want to ever be considered legit.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-measurements.jpg" />

So yeah, I drew out the plans and to be perfectly honest, I didn't look at them again during the CAD design.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-measurement-drawing.jpg" />

I iterated a couple times on my slot design, Initially the I ran a 24 hour print on the completed piece. This was a huge mistake, as there were a lot of support material required to ensure the flaps were properly attached.

I managed to save the print near the end and re-designed the slots to be in two pieces, then completed another print of the full size slow box and finished the prints off with two rectangular slot handles that I hot-glued on.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-slot-design.jpg" />

The completed slots turned out pretty awesome! Considering I sorta half assed teh measurements I'd kinda assumed I would have to sand down the edges of the plastic; however this was not the case and both fit snug into the toaster holes.

- [Christmas Toaster Slots - STL](/img/blog/2017/12/christmas-toaster-slots.stl)

- [Christmas Toaster Top - STL](/img/blog/2017/12/christmas-toaster-top.stl)

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-slot-outcome.jpg" />

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/toaster-slot-insert.gif" />
