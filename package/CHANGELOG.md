## 4.0.9

* screenManager
  * edgetoedge now is systemUiMode and is using SystemUiMode enum
  * Added hideSystemOverlay option to enable and disable hiding system overlays
* MeeduPlayerController 
  * Variable windows to desktopOrWeb 
  * Added excludeFocus variable (controls if widgets inside videoplayer should get focus or not)
  * Added enabledControls in which gesture controls can be disabled 
    * Defaults
      * this.escapeKeyCloseFullScreen = true,
      * this.numPadDecimalKeyToggleFit = true,
      * this.enterKeyOpensFullScreen = true,
      * this.spaceKeyTogglePlay = true,
      * this.volumeArrows = true,
      * this.seekArrows = true,
      * this.seekSwipes = true,
      * this.volumeSwipes = true,
      * this.brightnessSwipes = true,
      * this.doubleTapToSeek = true,
      * this.desktopDoubleTapToFullScreen = true
  * Added showLogs to be able to show and hide package logs
  * Added manageBrightness to make disable handling of brightness
* Fixed replay
* Updated License

  

## 4.0.8

* Fixed macos&ios errors and added steps to readme for it


## 4.0.7

* Fixed web build errors.
  
## 4.0.6

* Fixing pub points by using new video_player_media_kit.
  
## 4.0.5

* Fixing pub points.
  
## 4.0.4

* Fixing pub points.

## 4.0.3

* Fixing pub points.

## 4.0.2

* Added macos support in read me.
  
## 4.0.1

* Fixing pub points.

## 4.0.0

* Converted to using media_kit instead of dart_vlc.

## 3.2.0

* Using video player 2.6.0
* Adding http headers to videos played by files (to fix m3u8 files)

## 3.1.3

* Removed dependency on dio.
  
## 3.1.2

* Fixed Dart warnings
* Fixed formatting
  
## 3.1.1

* Fixed fit overflow
* Fixed 3.1.0 portrait duration overflow
  
## 3.1.0

* Portrait fixed view (by https://github.com/andrezanna)
* Updated window_manager to 0.3.0
  
## 3.0.5

* Disabled WakeLock on linux
* Added manageWakeLock to constructor incase someone wants to disable WakeLock
  
## 3.0.4

* Add linux docs (by https://github.com/secanonm)
  
## 3.0.3

* Fix linux (by https://github.com/secanonm)

## 3.0.2

* Fixed width errors in grid view 
* Added grid view example and updated links
  
## 3.0.1

* Fixed dispose player when launched in full screen mode
* Fixed wrong Orientation when launch as full screen
  
## 3.0.0

* Removed hotkey manger dependence to use flutter shortcuts widget (to work on web)
  
## 2.1.3

* Fixed web

## 2.1.2

* Fixed video player volume on windows causing errors
* Fixed focus in windows and add ui for changing volume in windows
* Improved initiation 

## 2.1.1

* Improved description
 
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
