# flutter_meedu_videoplayer

<a href="https://www.buymeacoffee.com/zezo357" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<a href='https://ko-fi.com/zezo357' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />

<a target="blank" href="https://pub.dev/packages/flutter_meedu_videoplayer"><img src="https://img.shields.io/pub/v/flutter_meedu_videoplayer?include_prereleases&style=flat-square"/></a>
<img src="https://img.shields.io/github/last-commit/zezo357/flutter_meedu_videoplayer/master?style=flat-square"/>
<img src="https://img.shields.io/github/license/zezo357/flutter_meedu_videoplayer?style=flat-square"/>

### Cross-Platform Video Player

We have implemented a cross-platform video player, which provides a seamless video playback experience.

- [video_player](https://pub.dev/packages/video_player) for Android, iOS, and web.
- [fvp](https://pub.dev/packages/fvp) for desktop platforms.

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

<table>
  <thead>
    <tr>
      <th>Feature</th>
      <th>iOS</th>
      <th>Android</th>
      <th>Windows</th>
      <th>Linux</th>
      <th>macOS</th>
      <th>Web</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Videos from Network</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Videos from Assets</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Videos from Local Files</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Looping</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>AutoPlay</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Swipe to Control Volume</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
    </tr>
    <tr>
      <td>Swipe to Seek</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
      <td>Keyboard Arrows</td>
    </tr>
    <tr>
      <td>FullScreen</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Launch Player in FullScreen</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Playback Speed</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Fast Forward/Rewind</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>SRT Subtitles</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>✔️</td>
    </tr>
    <tr>
      <td>Customization</td>
      <td>Partially</td>
      <td>Partially</td>
      <td>Partially</td>
      <td>Partially</td>
      <td>Partially</td>
      <td>Partially</td>
    </tr>
    <tr>
      <td>Picture in Picture (PIP)</td>
      <td>Not Implemented (Help Wanted)</td>
      <td>✔️</td>
      <td>✔️</td>
      <td>Implemented (Not tested)</td>
      <td>Implemented (Crashes, waiting for window_manager release, fixed in GitHub)</td>
      <td>Not Implemented</td>
    </tr>
  </tbody>
</table>

# Video Player Controls

## Mobile Controls

- Swipe horizontally to seek forward or backward in the video. (<em>seekSwipes</em>)
- Swipe vertically on the right side of the screen to control the video volume. (<em>volumeSwipes</em>)
- Swipe vertically on the left side of the screen to control the video brightness. (<em>brightnessSwipes</em>)
- Double-tap on the sides of the screen to seek forward or backward in the video. (<em>doubleTapToSeek</em>)
- Long press on the screen to speed up the video, and the video slows down when the long press is released. (<em>onLongPressSpeedUp</em>)

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
## Android (replace original video_player with fvp one)

1. Just add this package and set androidUseFVP to true in initMeeduPlayer
## iOS (replace original video_player with fvp one)

1. Just add this package in case you set iosUseFVP to true in initMeeduPlayer
### hls on web

Add to `pubspec.yaml`

```
  video_player_web_hls: ^1.0.0+3
```

Add

```javascript
<script
  src="https://cdn.jsdelivr.net/npm/hls.js@latest"
  type="application/javascript"
></script>
```

in index.html above

```javascript
<script src="main.dart.js" type="application/javascript"></script>
```

or above

```javascript
<script src="flutter.js" defer></script>
```
