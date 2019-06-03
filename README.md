#  Project 3 - Mumix

## Contributors 

XIanyu Li - 12487498

Christian Nguyen - 13254798

Yizhe Chen - 12670131

## Description 

Mumix, is a keyboard app for musicians who are away from home and want to conveniently test a melody that they have thought of. 

### Keyboard Scene

<kbd>
    <img src="readMeImages/piano screen.png"/>
</kbd>


On the bottom half of the keyboard scene, there is a playable piano with 24 keys that you can play by tapping on the keys.

On the keyboard scene, there are also looping drum pads that the user can enable to play. On each percussive instrument, there are three buttons with different labels:

- 1/4 - Which means the instrument should play 4 times in a given moment (4 quater notes in a bar)
- 1/2 - Which means the instrument should play 2 times in a given moment (2 half notes in a bar)
- 1 - Whichi means the instument should play 1 time in a a given moment (1 whole note in a bar)

### Settings Scene

<kbd>
    <img src="readMeImages/setting screen.png"/>
</kbd>


The piano's output can be modified in the settings scene through its:

- Attack - Which is the time taken for the ouput volume to reach from nil to peak.  
- Decay - Which is the time it takes to run down from the attack to the sustain.
- Sustain - Which is level of volume you hear when holding the key.
- Relase - Which is the time taken for the volume to drop to nil after releasing the key.

The settings also includes a Polyphonic/Monophonic switch, which determines whether the user wants to play multiple keys at a time or one respectively.

### Help Scene

<kbd>
    <img src="readMeImages/help screen.png"/>
</kbd>


If the user does not understand how to use the app, there is a help scene that they can look at to help them understand the app.

## Getting Started

### Prerequisites

1. Swift 5
2. AudioKit, AudioKitUI

### Installing

To install this and run this appplication:

1. FIRSTLY - Make sure you have Swift 5, if not, then update Xcode to the latest version.
2. Download and open this project folder
3. Click this link to download the AudioKit and AudioKitUI frameworks http://github.com/audiokit/AudioKit/releases/download/v4.7.2/AudioKit-iOS-4.7.2.zip
4. After downloading, unzip and open the file.
5. After opening the folder, the two frameworks should be there. Move the two frameworks into the project folder like below.

<kbd>
    <img src="readMeImages/install frame work.gif"/>
</kbd>

6. The applcation should be able to run after these steps.
