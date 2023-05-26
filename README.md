# flutter_meedu_videoplayer
<a href="https://www.buymeacoffee.com/zezo357" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<a href='https://ko-fi.com/zezo357' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />


<a target="blank" href="https://pub.dev/packages/flutter_meedu_videoplayer"><img src="https://img.shields.io/pub/v/flutter_meedu_videoplayer?include_prereleases&style=flat-square"/></a>
<img src="https://img.shields.io/github/last-commit/zezo357/flutter_meedu_videoplayer/master?style=flat-square"/>
<img src="https://img.shields.io/github/license/zezo357/flutter_meedu_videoplayer?style=flat-square"/>


### Cross-Platform Video Player
We have implemented a cross-platform video player, which provides a seamless video playback experience.

* [video_player](https://pub.dev/packages/video_player) for Android, iOS, and web.
* [media_kit](https://pub.dev/packages/media_kit) for desktop platforms.
  
👋 👉 <b>[Complete documentation here](https://zezo357.github.io/flutter_meedu_videoplayer/)</b>




<table>
<caption><h4><a href="https://zezo357.github.io/flutter_meedu_videoplayer_example/">Flutter Web Demo</a></h4></caption>

  <tbody>
    <tr>
      <td rowspan="2"><img src="https://zezo357.github.io/flutter_meedu_videoplayer/assets/q2.gif" alt="meedu_player" width="160" /></td>     
      <td><img src="https://zezo357.github.io/flutter_meedu_videoplayer/assets/full.gif" alt="meedu_player" width="300" /></td>      
    </tr>   
    <tr>
      <td><img src="https://zezo357.github.io/flutter_meedu_videoplayer/assets/playing_video.png" alt="meedu_player" width="300" /></td>     
    </tr>  
  </tbody>
</table>



<table><thead><tr><th>Feature</th><th>iOS</th><th>Android</th><th>Windows</th><th>Linux</th><th>macOS</th><th>Web</th></tr></thead><tbody><tr><td>Videos from Network</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Videos from Assets</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Videos from Local Files</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Looping</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>AutoPlay</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Swipe to Control Volume</td><td>✔️</td><td>✔️</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td></tr><tr><td>Swipe to Seek</td><td>✔️</td><td>✔️</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td><td>Keyboard Arrows</td></tr><tr><td>FullScreen</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Launch Player in FullScreen</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Playback Speed</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Fast Forward/Rewind</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>SRT Subtitles</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td><td>✔️</td></tr><tr><td>Customization</td><td>Partially</td><td>Partially</td><td>Partially</td><td>Partially</td><td>Partially</td><td>Partially</td></tr></tbody></table>


# Video Player Controls


## Mobile Controls
- Swipe horizontally to seek forward or backward in the video. (<em>seekSwipes</em>)
- Swipe vertically on the right side of the screen to control the video volume. (<em>volumeSwipes</em>)
- Swipe vertically on the left side of the screen to control the video brightness. (<em>brightnessSwipes</em>)
- Double-tap on the sides of the screen to seek forward or backward in the video. (<em>doubleTapToSeek</em>)

## Desktop Controls
- One-click with the mouse to toggle play and pause. (<em>desktopTapToPlayAndPause</em>)
- Double-click with the mouse to toggle full-screen mode. (<em>desktopDoubleTapToFullScreen</em>)
- Use the keyboard up and down arrows to increase or decrease the video volume. (<em>volumeArrows</em>)
- Use the keyboard right and left arrows to seek forward or backward in the video. (<em>seekArrows</em>)
- Press the Escape key to close full-screen mode. (<em>escapeKeyCloseFullScreen</em>)
- Press the NumPad Decimal key (.) to toggle the video fit. (<em>numPadDecimalKeyToggleFit</em>)
- Press the Enter key to open full-screen mode. (<em>enterKeyOpensFullScreen</em>)
- Press the Space key to toggle between playing and pausing the video. (<em>spaceKeyTogglePlay</em>)


## Initialize
```dart
void main() {
  initMeeduPlayer();
  runApp(MyApp());
}
```


# Setup

### Windows

Everything ready.

### Linux

System shared libraries from distribution specific user-installed packages are used by-default. You can install these as follows.

#### Ubuntu / Debian

```bash
sudo apt install libmpv-dev mpv
```

#### Packaging

There are other ways to bundle these within your app package e.g. within Snap or Flatpak. Few examples:

- [Celluloid](https://github.com/celluloid-player/celluloid/blob/master/flatpak/io.github.celluloid_player.Celluloid.json)
- [VidCutter](https://github.com/ozmartian/vidcutter/tree/master/_packaging)


## Note: macos is not tested (if you have any problems open an issue)
### macOS

Everything ready.

The minimum supported macOS version is 11.0,set MACOSX_DEPLOYMENT_TARGET = 11.0 `macos\Runner.xcodeproj\project.pbxproj`


Also, during the build phase, the following warnings are not critical and cannot be silenced:

```log
#import "Headers/media_kit_video-Swift.h"
        ^
/path/to/media_kit/media_kit_test/build/macos/Build/Products/Debug/media_kit_video/media_kit_video.framework/Headers/media_kit_video-Swift.h:270:31: warning: 'objc_ownership' only applies to Objective-C object or block pointer types; type here is 'CVPixelBufferRef' (aka 'struct __CVBuffer *')
- (CVPixelBufferRef _Nullable __unsafe_unretained)copyPixelBuffer SWIFT_WARN_UNUSED_RESULT;
```

```log
# 1 "<command line>" 1
 ^
<command line>:20:9: warning: 'POD_CONFIGURATION_DEBUG' macro redefined
#define POD_CONFIGURATION_DEBUG 1 DEBUG=1 
        ^
#define POD_CONFIGURATION_DEBUG 1
        ^
```

### iOS (replace original video_player with media_kit one)

1. The minimum supported iOS version is 13.0, so the target needs to be set IPHONEOS_DEPLOYMENT_TARGET to 13.0 in `ios\Runner.xcodeproj\project.pbxproj`
2. Just add this package in case you set iosUseMediaKit to true in initMeeduPlayer
```yaml
dependencies:
  ...
  media_kit_libs_ios_video: ^1.0.4         # iOS package for video (& audio) native libraries.
```
Also, software rendering is forced in the iOS simulator, due to an incompatibility with OpenGL ES.

### Android (replace original video_player with media_kit one)

1. Just add this package in case you set androidUseMediaKit to true in initMeeduPlayer
```yaml
dependencies:
  ...
  media_kit_libs_android_video: ^1.0.3           # Android package for video native libraries.
```

### hls on web

Add to `pubspec.yaml`
```     
  video_player_web_hls: ^1.0.0+3
```


Add
```javascript
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"  type="application/javascript"></script>
```
    
in index.html above   
```javascript
    <script src="main.dart.js" type="application/javascript"></script>
```
or above
```javascript
    <script src="flutter.js" defer></script>
```

