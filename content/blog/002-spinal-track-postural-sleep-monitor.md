+++
title = "SpinalTrack - Postural Sleep Monitor"
date = "2017-12-04T21:49:00+08:00"
tags = ["medical"]
categories = ["software"]
banner = "img/banners/introduction-to-makers-today.png"
+++

## Elevator Pitch
---

**SpinalTrack is a sleep monitor kit which provides incite and remediation for children growing up with Cerebral Palsy.**

Utilising the Walabot 3D imaging capabilities, orientation data of the sleeping body is captured and used to provide feedback on where extra support is needed to prevent spinal curvature and long term damage.

Behind the scenes the system makes use of `Machine Learning` (supervised logistic regression) to help train a `postural model` that can be used when flagging interesting events and even alerting via Amazon Alexa.

Real-time & historical events are streamed through `AWS Kinesis`, providing better analysis of the data captured. This is articulated by `Alexa` to the primary carer each morning; along with advice on where posture needs to be improved.

Walabot & Alexa combined will be a game changer in the research of preventative treatment for spinal curvature.

### BOM
---

* 1x - [Walabot](https://walabot.com)

### Problem Breakdown
---

Naturally during the night our bodies continue to work to keep us healthy. One of the important things we take for granted is how our bodies move into different positions where uncomfortable or begin to get sore.

This luxury is unfortunately not one available to all, where a portion of the population born with Cerebral Palsy don't have the muscle development needed to move around when uncomfortable during a nights rest.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/curvature-of-spine-01.jpeg" />

Newborns and early childhood suffers are particularly at risk, and if not enough attention is put into ensuring they sleep in the correct position, the damages to the spine and body will cause a lot of issues later in life.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/cerebral-palsy-sleep-position-01.jpg" />

As seen in the image above, the current method of ensuring the spine kept straight is by placing the child within foam blocks. Ultimately this is a cheap and simple solution to the problem, however there's another interesting effect lying on your back has overtime without too much variation.

Overtime the rib cage begins to flatten out as gravity has its strong effects in a concentrated spot. You can think of your chest as a balloon full of sand, gravity pushes down on it when you sleep on one side of your body and over a long period has noticeable physical effects on the body.

So it's clear that variation is key, and usually you will find that physios and OTs have the patients use a variety of moulds each week

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/cerebral-palsy-sleep-position-02.jpg" />

We aren't looking to replace the proven method of using the structured pillows, however we would like to extend and analyse the data

### Problem Outcomes
---

* **Trained Postural Model** - The main outcome we would like to achieve to to produce a trained model that can be applied to any visual recognition system to distinguish between good and bad sleep posture.

* **Walabot Hardware Integration** - The Walabot Hardware and SDK is key to our success, as it allows us to easily capture the bodies movements through the night without requiring the person to wear any invasive sensors.

* **Amazon Alexa as a Carer** - The next goal would be to have Alexa act as the Carer, she could give a daily breakdown of the high and low points of the nights sleep.

* **Alexa Controlling body movement** - This is a very long term goal if we have time, but it would be fantastic to look into how we could rig up and actuate a body brace to smoothly roll the patient around during the night.

### Existing Projects
---

We didn't want to just jump in without doing our research, especially on whether or not existing solutions could solves bits and pieces of the overall plan.

* [Walabot Sleep Tracker](https://www.hackster.io/kuzma/walabot-sleep-tracker-472740) - Appears to have solved some issues around monitoring sleep patterns in the form of movement. We would like to have a look and see if any of this project can be re-purposed to optimize our data capture of the body movement.

* [Sleep Restlessness Sensor for Neonates
](https://www.hackster.io/calvary-engineering-llc/sleep-restlessness-sensor-for-neonates-3750d9) - Seems to do something similar as the example above, however it implements things slightly different. A good spread of ideas are needed to help us produce a better project.