+++
title = "3D Printing Ethereum Wallet QR Code"
date = "2018-01-02T00:13:00+08:00"
tags = ["qrcode", "ethererum"]
categories = ["crypto", "3d-printing"]
banner = "img/blog/2018/01/3d-printed-qr-code-banner.png"
+++

## Introduction
---

Recently the price of crypto currencies has exploded. Through December 2017 we saw a massive value spike across the board on almost all major currencies, based mostly on the movements of BTC.

Whilst I'm not a huge fan of BTC currently (price surge and the networks scalability means that the cost per transaction is around 20USD), I do dabble in Ethereum (ETH).

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/eth-market-price-dec-jan.jpg" />

### Wallet Address
---

I used to have all my ETH stored in online wallets with my exchange, however recently I had a urge to begin mining currencies which spurred me to setup an offline wallet that I can manage myself.

One of the the outcomes of setting this wallet up was that I was given a public wallet address that I can use to reference my distributed currency on the blockchain.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/eth-wallet-address-qr-code.jpg" />

As you can see above, one of the neat things you can do with your wallet address is view it as a QR code. This simple thing gave me the interesting idea to 3D print a QR code version of my ETH wallet address that I could keep in my wallet.

### 3D Modeling a QR Code
---

In order to create the 3D model, I referred to this [Instructables tutorial](http://www.instructables.com/id/Create-a-3D-Printed-QR-Code-in-Blender/) about how to do it in Blender.

I generated the SVG of my QR Code by using [QRCode Monkey](http://www.qrcode-monkey.com/), however, there are a number of services online that will help you to do it. Remember to pick the quality and density of the QR code based on the limitations of your printer.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/eth-qr-code.svg" />

Once you have the SVG, load it into Blender using the import menu.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-svg-import.jpg" />

The layer will load into Blender with an awkward square background shape. You can remove this OR do what I did and simply hide the layer, as we will likely use this later on as a base plate for the QR code.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-svg-layer-remove.jpg" />

Next you want to select all the layers in the workspace. The easiest way to do this is to **hold CTRL** and **Click & Drag** around the pieces.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-qr-code-select.gif" />

Convert all the layers to a mesh by going to the **Object menu** (bottom left) and select **Convert To** then click **Mesh from Curve/Meta/Surf/Text**.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-qr-code-mesh.jpg" />

Merge all the layers into one object by going to the **Object menu** (bottom left) and select **Join**. You can alternatively press **CTRL+J**

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-qr-code-join.jpg" />

Next, extrude the single layer upwards by going into **Edit Mode**, and enable **Select faces**. Then do as you did before and select all the meshes in the workspace.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-qr-code-select-faces.jpg" />

Finally press the **E key** and **drag upward** to extrude.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/blender-qr-code-extrude.gif" />

### 3D Printing the QR Code
---

In order to 3D print the QR code, I needed a stable platform for the blocks to be etched onto. I decided to add a bottom layer to the code so that I wouldn't have to do any insane hotgluing later on.

The final results looked as follows in CURA. I had to scale the size down as Blender likes to export at a 1 meter scale.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/3d-printed-qr-code-cura.jpg" />

You can also find the Blender and STL files for my QR code here for reference:

- [3D Printed QR Wallet - STL](/img/blog/2018/01/3d-printed-WalletQR.stl)

- [3D Printed QR Wallet - Blender](/img/blog/2018/01/3d-printed-WalletQR.blend)

The plan was to quickly change the filament out half way into the print, just before or during the extrusion of the QR blocks. I had a lot of worries around what effects the hot printing tip would have on the base if left too long, however in the end I was able to swap out the reel in time so that no large amount of damage was caused.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/3d-printed-qr-code-final.jpg" />

The Final result worked out fantastic, however I did notice that the red was difficult for most of the QR apps I used to scan. I first thought that maybe in my stupidity I hadn't realised that QR can only be Black and White, however I later rules this out, as all QR apps seem to convert the image input to Black and White before reading anyway.

### BONUS: 3D Printed QR Cube
---

I also tried out how a cube would work if printed in a similar fashion (however I can't do the filament swap here).

I simply duplicated the base pattern for each side of a cube.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/3d-printed-qr-code-cube-blender.jpg" />

When loaded into CURA, the inside was hollowed out so that the print was cut down to sub 2 hours.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/3d-printed-qr-code-cube.jpg" />

- [3D Printed QR Wallet Cube - STL](/img/blog/2018/01/3d-printed-WalletQQCube.stl)

- [3D Printed QR Wallet Cube - Blender](/img/blog/2018/01/3d-printed-WalletQQCube.blend)

The final result for this experiment worked as expected, It doesn't scan exceptionally well due to the single colour; however the shape is very clear and defined and it's a neat little desk toy.

<img class="img-responsive image-box-shadow" src="/img/blog/2018/01/3d-printed-qr-code-cube-final.jpg" />

In the future it would be interesting producing little keychains, and if I ever get a dual extruder for multi-colour prints I could produce some nice little bricks!
