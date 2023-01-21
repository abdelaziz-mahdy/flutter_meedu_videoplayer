# flutter_meedu_videoplayer

### Cross-platform video player (macos not included)
- For Android, Ios and Web we are using video player
- For Windows and Linux we are using dart-vlc.
<table>
  <caption><h4>Demo</h4></caption>
  <tbody>
    <tr>
      <td rowspan="2"><img src="https://darwin-morocho.github.io/flutter-meedu-player/assets/q2.gif" alt="meedu_player" width="160" /></td>     
      <td><img src="https://darwin-morocho.github.io/flutter-meedu-player/assets/full.gif" alt="meedu_player" width="300" /></td>      
    </tr>   
    <tr>
      <td><img src="https://user-images.githubusercontent.com/15864336/94494352-9924d100-01b4-11eb-9c0f-54c88868331b.png" alt="meedu_player" width="300" /></td>     
    </tr>  
  </tbody>
</table>


| Features  | iOS | Android | windows | linux | macos | web|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| Videos from Network  | ✅  | ✅ | ✅ | ✅ | x | ✅|
| Videos from Assets  | ✅  | ✅ | ✅ | ✅ | x | ✅|
| Videos from local files  | ✅  | ✅ | ✅ | ✅ | x | ✅
| Looping  | ✅  | ✅ | x | x | x | x
| AutoPlay  | ✅  | ✅ | ✅ | ✅ | x | ✅
| Swipe to increase and decrease Sound  | ✅  | ✅ | x | x | x | x |
| Swipe to seek in video | ✅  | ✅ | x | x | x | x |
| FullScreen  | ✅  | ✅ | ✅ | ✅ | x | ✅ |
| Launch Player as FullScreen  | ✅  | ✅ | ✅ | ✅ | x | ✅ |
| Playback Speed  | ✅  | ✅ | ✅ | ✅ | x | ✅ |
| fastForward / Rewind  | ✅  | ✅ | ✅ | ✅ |x | ✅ |
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


## Setup

### Windows

Everything is already set up.

### Linux

For using this plugin on Linux, you must have [VLC](https://www.videolan.org) & [libVLC](https://www.videolan.org/vlc/libvlc.html) installed.

**On Ubuntu/Debian:**

```bash
sudo apt-get install vlc
```

```bash
sudo apt-get install libvlc-dev
```

**On Fedora:**

```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

```bash
sudo dnf install vlc
```

```bash
sudo dnf install vlc-devel
```



👋 👉 <b>[Complete documentation here](https://player.meedu.app)</b>



