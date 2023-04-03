# flutter_meedu_videoplayer
<a href="https://www.buymeacoffee.com/zezo357" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<a href='https://ko-fi.com/zezo357' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />


<a target="blank" href="https://pub.dev/packages/flutter_meedu_videoplayer"><img src="https://img.shields.io/pub/v/flutter_meedu_videoplayer?include_prereleases&style=flat-square"/></a>
<img src="https://img.shields.io/github/last-commit/zezo357/flutter_meedu_videoplayer/master?style=flat-square"/>
<img src="https://img.shields.io/github/license/zezo357/flutter_meedu_videoplayer?style=flat-square"/>


### Cross-platform video player
- For Android, Ios and Web we are using video player
- For Windows and Linux and macos we are using media_kit.
<table>
  <caption><h4>Demo</h4></caption>
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


| Features  | iOS | Android | windows | linux | macos | web|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| Videos from Network  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅|
| Videos from Assets  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅|
| Videos from local files  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅
| Looping  | ✅  | ✅ | x | x | x | x
| AutoPlay  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅
| Swipe to increase and decrease Sound  | ✅  | ✅ | keyboard arrows | keyboard arrows | ✅ | keyboard arrows |
| Swipe to seek in video | ✅  | ✅ | keyboard arrows | keyboard arrows | ✅ | keyboard arrows |
| FullScreen  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅ |
| Launch Player as FullScreen  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅ |
| Playback Speed  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅ |
| fastForward / Rewind  | ✅  | ✅ | ✅ | ✅ | ✅ | ✅ |
| srt subtitles  | ✅  | ✅ | x | x | x | x
| Customize  | partially  | partially | partially | partially | x | partially

---



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


The minimum supported macOS version is 11.0

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
  media_kit_libs_ios_video: ^1.0.1         # iOS package for video (& audio) native libraries.
```

Also, software rendering is forced in the iOS simulator, due to an incompatibility with OpenGL ES.


👋 👉 <b>[Complete documentation here](https://zezo357.github.io/flutter_meedu_videoplayer/)</b>



