## 3.0.5
* disabled WakeLock on linux
* added manageWakeLock to constructor incase someone wants to disable WakeLock
## 3.0.4
* add linux docs (by https://github.com/secanonm)
## 3.0.3
* fix linux (by https://github.com/secanonm)

## 3.0.2
* fixed width errors in grid view 
* added grid view example and updated links
## 3.0.1
* fixed dispose player when launched in full screen mode
* fixed wrong Orientation when launch as full screen
## 3.0.0
* removed hotkey manger dependence to use flutter shortcuts widget (to work on web)
  
## 2.1.3
* fixed web

## 2.1.2
* fixed video player volume on windows causing errors
* fixed focus in windows and add ui for changing volume in windows
* improved initiation 

## 2.1.1
* improved description
 
## 2.1.0
* Converted to using video player platform interface (using package video_player_dart_vlc)
* fixed web build
* initDartVlc now is initVideoPlayerDartVlcIfNeeded
* when full screen closed disabled the forced portrait orientation 
* fixed bug where video player were disposed when closing full screen

## 2.0.5
* fixed dart vlc initialize

## 2.0.4
* updated dart vlc version

## 2.0.3
* separated init dart vlc to try fixing ffi for web

## 2.0.2
* initial videoPlayer with null fixed
* button sizing improved
* windows window overflow fixed(when returning from full screen)
* timer is null in some cases
## 2.0.1
[Windows] optional ability to restore app hotkeys
[Windows] fix of null-check exception on pushing player's mute button
both by nikitatg
## 2.0.0
Due to dart vlc update 
    BREAKING CHANGES
    Removed macOS support
## 1.0.3
* Removed use native view from example due to instability.
## 1.0.2
* Fixed Error in example code.
* Removed pubspec web support (since web doesn't work at the moment)


## 1.0.1
* Edited readme.

## 1.0.0
* Initial release.
