# flutter_meedu_videoplayer



## Cross-platform video player (web,macos not included)
- Android and Ios are using video player
- Desktop are using dart-vlc


## Used meedu player as a base and added (also fixed some errors)
- swipe to increase and decrease volume 
- swipe to seek 
- integrated wake lock in the code


## Setup For windows 
1.Add in main 
```dart
  initVideoPlayerDartVlcIfNeeded();
```
Example:
```dart
void main() {
  initVideoPlayerDartVlcIfNeeded();
  runApp(MyApp());
}
```


<img src="https://darwin-morocho.github.io/flutter-meedu-player/assets/q2.gif" alt="meedu_player" width="160" />
<br/>
<img src="https://darwin-morocho.github.io/flutter-meedu-player/assets/full.gif" alt="meedu_player" width="300" />
<img src="https://user-images.githubusercontent.com/15864336/94494352-9924d100-01b4-11eb-9c0f-54c88868331b.png" alt="meedu_player" width="300" />

| Features  | iOS | Android | windows | linux | macos | web
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| Videos from Network  | ✅  | ✅ | ✅ | ✅ | x | ✅
| Videos from Assets  | ✅  | ✅ | ✅ | ✅ | x | ✅
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

👋 👉 <b>[Complete documentation here](https://player.meedu.app)</b>
