# Idasen Desk Controller – Mac app


This is a Mac Status Bar application for controlling your [IKEA IDÅSEN (Linak) Desk](https://www.ikea.com/au/en/p/idasen-desk-sit-stand-black-beige-s79280979/)

If you find this at least a little bit useful, why don't you help me out by:
* Starring this project
* Shout me a cup of coffe via [PayPal](https://paypal.me/dtw/5)
* Follow me on Twitter [@davidwilliames](https://twitter.com/davidwilliames)

---

![Animated example](/images/example.gif)

![Preferences example](/images/preferences_example.png)

---

## Why?

The best way I've found to get myself to use my sit/stand desk more; is to remove as much friction around moving it as possible.

The Linak 'Desk Control' mobile app let's you set favourite positions — but then you need to open the app, and press **and hold** the up/down arrow until it get's into position. Having to hold the button the whole time was just a bit annoying for me; and I found myself changing height positions less.

I found a couple of different solutions across Github; but there were no truly Native Mac apps... until now.

I'm already on my Mac when sitting/standing at my desk — so why can't I quickly control the desk from here; without needing to open Linak's Desk Control Mobile app or having to use physical controller?


## Features

* Easy access from the Mac Status Bar
* View current height
* Save sit/stand height positions 
* Move up/down
* Move to sit/stand position without having to hold down the button
* Automatic launch on startup (configurable in preferences)
* Supports AppleScript to interact with it (e.g. via an [Alfred App](https://www.alfredapp.com) workflow)


![Animated example](/images/status_bar_example.png)
![App icon](/images/Icon.png)

## Getting started

* Download the 'Desk Controller' App, and move it to your 'Applications' folder
* Double-click to open it
* Now it will show up in your Status Bar

Other info:
* To access the preferences either right-click on the Status bar icon and click `Preferences` – or after clicking on the icon, click on the settings icon in the bottom right
* To quit the application entirely; right-click on the Status bar icon and click `Quit`


## Troublshooting

* Make sure no other phones / computers currently have one of the 'Desk Control' apps open and connected to your desk, if you do, simply quit that app, and this Desk Controller app should work
* Make sure your Idasen Desk still has the word "Desk" in the name of the device — e.g if you changed its name via Linak's Desk Control mobile app
* If it's still not finding your desk; try resetting your desk; to do this:
    1. Lower your desk as low as it goes
    2. Now once more hold down the physical controller to lower it even more, after a second or 2 it should jump down and up
    3. Now press and hold the 'bluetooth' button on the front of the physical controller, for a few seconds – until the blue light starts blinking
    
---

## Interacting with AppleScript

If you want to interact with your Desk via AppleScript; you can talk directly through the 'Desk Controller' mac app.

This is great for setting up an  [Alfred App](https://www.alfredapp.com) workflow

#### Commands:

`move "to-sit"`: Will move to the saved 'Sitting position'

`move "to-stand"`: Will move to the saved 'Standing position'

`move "up"`: Will move the desk up a tiny bit

`move "down"`: Will move the desk down a tiny bit


So you may have an AppleScript script that looks like this:
``` AppleScript
tell application "Desk Controller"
    move "to-sit"
end tell
```

