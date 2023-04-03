# flutter_meedu_videoplayer
<a href="https://www.buymeacoffee.com/zezo357" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<a href='https://ko-fi.com/zezo357' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />

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

Due to media_kit compilation fails these needs to be added (thats a workaround for now until this fix is released)

```yaml
dependency_overrides:
  media_kit:
    git:
      url: https://github.com/zezo357/media_kit
      ref: 6fc3720bea0b162262c9dc48e655b34cfa66903f
      path: ./media_kit
  media_kit_video:
    git:
      url: https://github.com/zezo357/media_kit
      ref: 6fc3720bea0b162262c9dc48e655b34cfa66903f
      path: ./media_kit_video
  media_kit_libs_ios_video:
    git:
      url: https://github.com/zezo357/media_kit
      ref: 6fc3720bea0b162262c9dc48e655b34cfa66903f
      path: ./media_kit_libs_ios_video
  media_kit_native_event_loop:
    git:
      url: https://github.com/zezo357/media_kit
      ref: 6fc3720bea0b162262c9dc48e655b34cfa66903f
      path: ./media_kit_native_event_loop
  media_kit_libs_macos_video:
    git:
      url: https://github.com/zezo357/media_kit
      ref: 6fc3720bea0b162262c9dc48e655b34cfa66903f
      path: ./media_kit_libs_macos_video
```


### iOS (replace original video_player with media_kit one)

1. set IPHONEOS_DEPLOYMENT_TARGET to 13.0 in `ios\Runner.xcodeproj\project.pbxproj`
2. Just add this package in case you set iosUseMediaKit to true in initMeeduPlayer

```yaml
dependencies:
  ...
  media_kit_libs_ios_video: ^1.0.0         # iOS package for video (& audio) native libraries.
```



👋 👉 <b>[Complete documentation here](https://zezo357.github.io/flutter_meedu_videoplayer/)</b>



