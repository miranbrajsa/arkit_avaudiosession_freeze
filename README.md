# An iOS 13 ARKit, AVAudioSession bug report demo application
This application serves as a proof of concept for the mentioned bug reproduction.

## What does the application do
The application starts a new AR world tracking session upon view controller presentation. After the view controller has been made visible, it attaches a positional audio source (resources and code re-used from Apple's [Creating an Immersive AR Experience with Audio](https://developer.apple.com/documentation/arkit/creating_an_immersive_ar_experience_with_audio) example) to the camera PoV node. Upon view controller dismissal, it removes the positional audio node from the camera PoV and pauses the AR session.

## The problem
Up until iOS 13 this scenario worked without any issues. On iOS 13 however, this scenario causes a bug which disables us from hearing a positional audio on second and all other subsequent view controller presentations. The bug manifests as a 5-6 second camera freeze upon ARSession initialization, followed by no sound. On first run everything runs OK.

## The three scenarios
Three scenarios have been put together to demonstrate various ARKitSession and AVAudioSession pair handling on iOS 12 and iOS 13.

### The first scenario _[THE DEFAULT]_
The `ARKit` session has been configured to provide audio data by setting `configuration.provideAudioData` to `true`. No manual `AVAudioSession` management is being done.

iOS 12: **works**

iOS 13: **does NOT work**

_Reproduction steps:_
1. Run the demo app from this repository on your device.
2. Select the first cell/scenario labeled "ARSession + automatic AVAudioSession management"
3. The ARKit session should start immediately and you should hear the sound
4. Tap on "Back" button
5. Select the first cell/scenario once again

_Expected behavior (for both iOS versions 12 and 13):_

6. The ARKit session should start immediately and you should hear the sound

_Actual behavior:_

6. [iOS 12] The ARKit session starts immediately and sound can be heard
6. [iOS 13] The ARKit session takes 5-6 seconds to start manifesting a frozen camera screen and there's no sound afterwards

### The seconds scenario
The `ARKit` session has been configured not to provide audio data by leaving `configuration.provideAudioData` on its default setting of `false`. `AVAudioSession` is manually started in `viewWillAppear` and manually paused in `viewDidDisappear`.

iOS 12: **does NOT work**

iOS 13: **does NOT work**

_Reproduction steps:_
1. Run the demo app from this repository on your device.
2. Select the second cell/scenario labeled "ARSession + manual AVAudioSession management"
3. The ARKit session should start immediately and you should hear the sound
4. Tap on "Back" button
5. Select the second cell/scenario once again

_Expected behavior (for both iOS versions 12 and 13):_

6. The ARKit session should start immediately and you should hear the sound

_Actual behavior (for both iOS versions 12 and 13):_

6. The ARKit session takes 5-6 seconds to start manifesting a frozen camera screen and there's no sound afterwards

### The third scenario
The `ARKit` session has been configured not to provide audio data by leaving `configuration.provideAudioData` on its default setting of `false`. `AVAudioSession` is manually started in `viewWillAppear` and never paused.

iOS 12: **works**

iOS 13: **works**

_Reproduction steps:_
1. Run the demo app from this repository on your device.
2. Select the third cell/scenario labeled "ARSession + manual AVAudioSession management without deactivating the AVAudioSession"
3. The ARKit session should start immediately and you should hear the sound
4. Tap on "Back" button
5. Select the second cell/scenario once again

_Expected behavior (for both iOS versions 12 and 13):_

6. The ARKit session should start immediately and you should hear the sound

_Actual behavior (for both iOS versions 12 and 13):_

6. The ARKit session starts immediately and sound can be heard

### Conclusion
The only solution which works on both platform versions is solution **No. #3**
