import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/fullscreen_page.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock/wakelock.dart';
import 'package:universal_platform/universal_platform.dart';

enum ControlsStyle { primary, secondary }

class MeeduPlayerController {
  /// the video_player controller
  VideoPlayerController? _videoPlayerController;
  //final _pipManager = PipManager();
  StreamSubscription? _playerEventSubs;

  /// Screen Manager to define the overlays and device orientation when the player enters in fullscreen mode
  final ScreenManager screenManager;

  /// use this class to change the default icons with your custom icons
  CustomIcons customIcons;

  /// use this class to hide some buttons in the player
  EnabledButtons enabledButtons;

  /// the playerStatus to notify the player events like paused,playing or stopped
  /// [playerStatus] has a [status] observable
  final MeeduPlayerStatus playerStatus = MeeduPlayerStatus();

  /// the dataStatus to notify the load sources events
  /// [dataStatus] has a [status] observable
  final MeeduPlayerDataStatus dataStatus = MeeduPlayerDataStatus();
  final Color colorTheme;
  final bool controlsEnabled;
  String? _errorText;
  String? get errorText => _errorText;
  Widget? loadingWidget, header, bottomRight;
  final ControlsStyle controlsStyle;
  //final bool pipEnabled, showPipButton;

  String? tag;

  // OBSERVABLES
  final Rx<Duration> _position = Rx(Duration.zero);
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  final Rx<Duration> _duration = Rx(Duration.zero);
  final Rx<int> _swipeDuration = 0.obs;
  Rx<int> doubleTapCount = 0.obs;
  final Rx<double> _currentVolume = 1.0.obs;
  final Rx<double> _playbackSpeed = 1.0.obs;
  final Rx<double> _currentBrightness = 0.0.obs;
  final Rx<List<DurationRange>> _buffered = Rx([]);
  Rx<double> bufferedPercent = Rx(0.0);
  final Rx<bool> _closedCaptionEnabled = false.obs;
  final Rx<bool> _mute = false.obs;
  final Rx<bool> _fullscreen = false.obs;
  final Rx<bool> _showControls = true.obs;
  final Rx<bool> _showSwipeDuration = false.obs;
  final Rx<bool> _showVolumeStatus = false.obs;
  final Rx<bool> _showBrightnessStatus = false.obs;

  Rx<bool> videoFitChanged = false.obs;
  final Rx<BoxFit> _videoFit = Rx(BoxFit.fill);
  //Rx<double> scale = 1.0.obs;
  Rx<bool> rewindIcons = false.obs;
  Rx<bool> forwardIcons = false.obs;
  // NO OBSERVABLES
  bool _isSliderMoving = false;
  bool _looping = false;
  bool _autoplay = false;
  double _volumeBeforeMute = 0;
  double mouseMoveInitial = 0;
  Timer? _timer;
  Timer? _timerForSeek;
  Timer? _timerForVolume;
  Timer? _timerForGettingVolume;
  Timer? timerForTrackingMouse;
  Timer? videoFitChangedTimer;
  Rx<bool> bufferingVideoDuration = false.obs;
  void Function()? onVideoPlayerClosed;
  List<BoxFit> fits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitHeight,
    BoxFit.fitWidth,
    BoxFit.scaleDown
  ];

  // GETS
  StreamSubscription? positionStream;
  StreamSubscription? volumeStream;
  StreamSubscription? playBackStream;
  StreamSubscription? bufferStream;

  /// use this stream to listen the player data events like none, loading, loaded, error
  Stream<DataStatus> get onDataStatusChanged => dataStatus.status.stream;

  /// use this stream to listen the player data events like stopped, playing, paused
  Stream<PlayerStatus> get onPlayerStatusChanged => playerStatus.status.stream;

  /// current position of the player
  Rx<Duration> get position => _position;

  /// use this stream to listen the changes in the video position
  Stream<Duration> get onPositionChanged => _position.stream;

  /// duration of the video
  Rx<Duration> get duration => _duration;

  /// use this stream to listen the changes in the video duration
  Stream<Duration> get onDurationChanged => _duration.stream;

  /// [mute] is true if the player is muted
  Rx<bool> get mute => _mute;
  Stream<bool> get onMuteChanged => _mute.stream;

  /// [fullscreen] is true if the player is in fullscreen mode
  Rx<bool> get fullscreen => _fullscreen;
  Stream<bool> get onFullscreenChanged => _fullscreen.stream;

  /// [showControls] is true if the player controls are visible
  Rx<bool> get showControls => _showControls;
  Stream<bool> get onShowControlsChanged => _showControls.stream;

  /// [showSwipeDuration] is true if the player controls are visible
  Rx<bool> get showSwipeDuration => _showSwipeDuration;
  Stream<bool> get onShowSwipeDurationChanged => _showSwipeDuration.stream;

  /// [showSwipeDuration] is true if the player controls are visible
  Rx<bool> get showVolumeStatus => _showVolumeStatus;
  Stream<bool> get onShowVolumeStatusChanged => _showVolumeStatus.stream;

  /// [showSwipeDuration] is true if the player controls are visible
  Rx<bool> get showBrightnessStatus => _showBrightnessStatus;
  Stream<bool> get onShowBrightnessStatusChanged =>
      _showBrightnessStatus.stream;

  /// [swipeDuration] is true if the player controls are visible
  Rx<int> get swipeDuration => _swipeDuration;
  Stream<int> get onSwipeDurationChanged => _swipeDuration.stream;

  /// [volume] is true if the player controls are visible
  Rx<double> get volume => _currentVolume;
  Stream<double> get onVolumeChanged => _currentVolume.stream;

  /// [volume] is true if the player controls are visible
  Rx<double> get brightness => _currentBrightness;
  Stream<double> get onBrightnessChanged => _currentBrightness.stream;

  /// [sliderPosition] the video slider position
  Rx<Duration> get sliderPosition => _sliderPosition;
  Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  /// [bufferedLoaded] buffered Loaded for network resources
  Rx<List<DurationRange>> get buffered => _buffered;
  Stream<List<DurationRange>> get onBufferedChanged => _buffered.stream;

  /// [videoPlayerController] instace of VideoPlayerController
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  /// the playback speed default value is 1.0
  double get playbackSpeed => _playbackSpeed.value;

  /// [looping] is true if the player is looping
  bool get looping => _looping;

  /// [autoPlay] is true if the player has enabled the autoplay
  bool get autoplay => _autoplay;

  Rx<bool> get closedCaptionEnabled => _closedCaptionEnabled;
  Stream<bool> get onClosedCaptionEnabledChanged =>
      _closedCaptionEnabled.stream;

  bool windows = false;

  /// [isInPipMode] is true if pip mode is enabled
  //Rx<bool> get isInPipMode => _pipManager.isInPipMode;
  //Stream<bool?> get onPipModeChanged => _pipManager.isInPipMode.stream;

  Rx<bool> isBuffering = false.obs;
  SharedPreferences? prefs;

  /// returns the os version
  //Future<double> get osVersion async {
  //return _pipManager.osVersion;
  //}

  /// returns true if the pip mode can used on the current device, the initial value will be false after check if pip is available
  //Rx<bool> get pipAvailable => _pipAvailable;

  /// return fit of the Video,By default it is set to [BoxFit.contain]
  Rx<BoxFit> get videoFit => _videoFit;

  /// creates an instance of [MeeduPlayerControlle]
  ///
  /// [screenManager] the device orientations and overlays
  /// [placeholder] widget to show when the player is loading a video
  /// [controlsEnabled] if the player must show the player controls
  /// [errorText] message to show when the load process failed
  MeeduPlayerController({
    this.screenManager = const ScreenManager(),
    this.colorTheme = Colors.redAccent,
    Widget? loadingWidget,
    this.controlsEnabled = true,
    String? errorText,
    this.controlsStyle = ControlsStyle.primary,
    this.header,
    this.bottomRight,
    //this.pipEnabled = false,
    //this.showPipButton = false,
    this.customIcons = const CustomIcons(),
    this.enabledButtons = const EnabledButtons(),
    this.onVideoPlayerClosed,
  }) {
    getUserPreferenceForFit();

    _errorText = errorText;
    tag = DateTime.now().microsecondsSinceEpoch.toString();
    this.loadingWidget = loadingWidget ??
        SpinKitWave(
          size: 30,
          color: colorTheme,
        );
    if (UniversalPlatform.isWindows ||
        UniversalPlatform.isLinux ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isWeb) {
      windows = true;
    }
    //check each
    if (!windows) {
      VolumeController().listener((newVolume) {
        volume.value = newVolume;
      });
    }

    _playerEventSubs = onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
        } else {
          Wakelock.disable();
        }
      },
    );

    //if (pipEnabled) {
    // get the OS version and check if pip is available
    //this._pipManager.checkPipAvailable().then(
    //(value) => _pipAvailable.value = value,
    //);
    // listen the pip mode changes
    //_pipModeWorker = _pipManager.isInPipMode.ever(this._onPipModeChanged);
    //} else {
    //_pipAvailable.value = false;
    //}
  }
  Future<void> registerHotKeys() async {
    if (HotKeyManager.instance.registeredHotKeyList.isEmpty &&
        !UniversalPlatform.isWeb) {
      HotKey arrowUP = HotKey(
        KeyCode.arrowUp,
        scope: HotKeyScope.inapp,
      );
      HotKey arrowDown = HotKey(
        KeyCode.arrowDown,
        scope: HotKeyScope.inapp,
      );
      HotKey arrowRight = HotKey(
        KeyCode.arrowRight,
        scope: HotKeyScope.inapp,
      );
      HotKey arrowLeft = HotKey(
        KeyCode.arrowLeft,
        scope: HotKeyScope.inapp,
      );
      HotKey escape = HotKey(
        KeyCode.escape,
        scope: HotKeyScope.inapp,
      );
      HotKey enter = HotKey(
        KeyCode.enter,
        scope: HotKeyScope.inapp,
      );
      HotKey spaceBar = HotKey(
        KeyCode.space,
        scope: HotKeyScope.inapp,
      );
      HotKey dot = HotKey(
        KeyCode.numpadDecimal,
        scope: HotKeyScope.inapp,
      );
      await HotKeyManager.instance.register(
        arrowUP,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          setVolume(volume.value + 0.05);
        },
      );
      await HotKeyManager.instance.register(
        arrowDown,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          setVolume(volume.value - 0.05);
        },
      );
      await HotKeyManager.instance.register(
        arrowRight,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          seekTo(position.value + const Duration(seconds: 5));
        },
      );
      await HotKeyManager.instance.register(
        arrowLeft,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          seekTo(position.value - const Duration(seconds: 5));
        },
      );

      await HotKeyManager.instance.register(
        escape,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          screenManager.setWindowsFullScreen(false, this);
        },
      );
      await HotKeyManager.instance.register(
        enter,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          screenManager.setWindowsFullScreen(!_fullscreen.value, this);
        },
      );
      await HotKeyManager.instance.register(
        spaceBar,
        keyDownHandler: (hotKey) {
          print('onKeyDown+${hotKey.toJson()}');
          if (playerStatus.playing) {
            pause();
          } else {
            play();
          }
        },
      );
      await HotKeyManager.instance.register(
        dot,
        keyDownHandler: (hotKey) {
          toggleVideoFit();
        },
      );
    } else {
      print("hotkeys are registered ");
    }
    //await HotKeyManager.instance.unregister(_hotKey);
  }

  /// create a new video_player controller
  VideoPlayerController _createVideoController(DataSource dataSource) {
    VideoPlayerController tmp; // create a new video controller
    //dataSource = await checkIfm3u8AndNoLinks(dataSource);
    if (dataSource.type == DataSourceType.asset) {
      tmp = VideoPlayerController.asset(
        dataSource.source!,
        closedCaptionFile: dataSource.closedCaptionFile,
        package: dataSource.package,
      );
    } else if (dataSource.type == DataSourceType.network) {
      tmp = VideoPlayerController.network(
        dataSource.source!,
        formatHint: dataSource.formatHint,
        closedCaptionFile: dataSource.closedCaptionFile,
        httpHeaders: dataSource.httpHeaders ?? {},
      );
    } else {
      tmp = VideoPlayerController.file(
        dataSource.file!,
        closedCaptionFile: dataSource.closedCaptionFile,
      );
    }
    return tmp;
  }

  /// initialize the video_player controller and load the data source
  Future _initializePlayer({
    Duration seekTo = Duration.zero,
  }) async {
    if (seekTo != Duration.zero) {
      print("Called seek function to" + seekTo.toString());
      await this.seekTo(seekTo);
    }

    // if the playbackSpeed is not the default value
    if (_playbackSpeed != 1.0) {
      await setPlaybackSpeed(_playbackSpeed.value);
    }

    if (_looping) {
      await setLooping(_looping);
    }

    if (_autoplay) {
      // if the autoplay is enabled
      await play();
    }
  }

  void _listener() {
    final value = _videoPlayerController!.value;
    // set the current video position
    final position = value.position;
    _position.value = position;
    if (!_isSliderMoving) {
      _sliderPosition.value = position;
    }

    // set the video buffered loaded
    final buffered = value.buffered;

    if (buffered.isNotEmpty) {
      _buffered.value = buffered;
      isBuffering.value =
          value.isPlaying && position.inSeconds >= buffered.last.end.inSeconds;
      bufferedPercent.value =
          buffered.last.end.inSeconds / duration.value.inSeconds;
    }

    // save the volume value
    final volume = value.volume;
    if (!mute.value && _volumeBeforeMute != volume) {
      _volumeBeforeMute = volume;
    }

    // check if the player has been finished
    if (_position.value.inSeconds >= duration.value.inSeconds &&
        !playerStatus.stopped) {
      playerStatus.status.value = PlayerStatus.stopped;
    }
  }

  /// set the video data source
  ///
  /// [autoPlay] if this is true the video automatically start
  Future<void> setDataSource(
    DataSource dataSource, {
    bool autoplay = true,
    bool looping = false,
    Duration seekTo = Duration.zero,
  }) async {
    try {
      _autoplay = autoplay;
      _looping = looping;
      dataStatus.status.value = DataStatus.loading;

      // if we are playing a video
      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isPlaying) {
        await pause(notify: false);
      }

      // save the current video controller to be disposed in the next frame
      VideoPlayerController? oldController = _videoPlayerController;

      _videoPlayerController = _createVideoController(dataSource);
      await _videoPlayerController!.initialize();

      if (oldController != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          oldController.removeListener(_listener);
          await oldController
              .dispose(); // dispose the previous video controller
        });
      }

      // set the video duration
      print("Duration is ${_videoPlayerController!.value.duration}");
      _duration.value = _videoPlayerController!.value.duration;

      /// notify that video was loaded
      dataStatus.status.value = DataStatus.loaded;

      await _initializePlayer(seekTo: seekTo);
      // listen the video player events
      _videoPlayerController!.addListener(_listener);
    } catch (e, s) {
      print(e);
      print(s);
      _errorText ??= _videoPlayerController!.value.errorDescription ?? "$e";
      dataStatus.status.value = DataStatus.error;
    }
  }

  /// play the current video
  ///
  /// [repeat] if is true the player go to Duration.zero before play
  Future<void> play({bool repeat = false}) async {
    if (repeat) {
      await seekTo(Duration.zero);
    }

    await _videoPlayerController?.play();
    await getCurrentVolume();
    await getCurrentBrightness();

    playerStatus.status.value = PlayerStatus.playing;
    screenManager.setOverlays(false);
    _hideTaskControls();
  }

  /// pause the current video
  ///
  /// [notify] if is true and the events is not null we notifiy the event
  Future<void> pause({bool notify = true}) async {
    await _videoPlayerController?.pause();
    playerStatus.status.value = PlayerStatus.paused;
  }

  /// seek the current video position
  Future<void> seekTo(Duration position) async {
    _position.value = position;
    print("duration in seek function is ${duration.value.toString()}");
    if (duration.value.inSeconds != 0) {
      if (position <= duration.value) {
        await _videoPlayerController?.seekTo(position);
      } else {
        await _videoPlayerController
            ?.seekTo(duration.value - const Duration(milliseconds: 100));
      }
      if (playerStatus.stopped) {
        play();
      }
    } else {
      _timerForSeek?.cancel();
      _timerForSeek =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
        //_timerForSeek = null;
        print("SEEK CALLED");
        if (duration.value.inSeconds != 0) {
          if (position <= duration.value) {
            await _videoPlayerController?.seekTo(position);
          } else {
            await _videoPlayerController
                ?.seekTo(duration.value - const Duration(milliseconds: 100));
          }
          if (playerStatus.stopped) {
            play();
          }
          t.cancel();
          //_timerForSeek = null;
        }
      });
    }
  }

  /// Sets the playback speed of [this].
  ///
  /// [speed] indicates a speed value with different platforms accepting
  /// different ranges for speed values. The [speed] must be greater than 0.
  ///
  /// The values will be handled as follows:
  /// * On web, the audio will be muted at some speed when the browser
  ///   determines that the sound would not be useful anymore. For example,
  ///   "Gecko mutes the sound outside the range `0.25` to `5.0`" (see https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/playbackRate).
  /// * On Android, some very extreme speeds will not be played back accurately.
  ///   Instead, your video will still be played back, but the speed will be
  ///   clamped by ExoPlayer (but the values are allowed by the player, like on
  ///   web).
  /// * On iOS, you can sometimes not go above `2.0` playback speed on a video.
  ///   An error will be thrown for if the option is unsupported. It is also
  ///   possible that your specific video cannot be slowed down, in which case
  ///   the plugin also reports errors.
  Future<void> setPlaybackSpeed(double speed) async {
    await _videoPlayerController?.setPlaybackSpeed(speed);
    _playbackSpeed.value = speed;
  }

  Future<void> togglePlaybackSpeed() async {
    List<double> allowedSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
    if (allowedSpeeds.indexOf(_playbackSpeed.value) <
        allowedSpeeds.length - 1) {
      setPlaybackSpeed(
          allowedSpeeds[allowedSpeeds.indexOf(_playbackSpeed.value) + 1]);
    } else {
      setPlaybackSpeed(allowedSpeeds[0]);
    }
  }

  /// Sets whether or not the video should loop after playing once
  Future<void> setLooping(bool looping) async {
    await _videoPlayerController?.setLooping(looping);
    _looping = looping;
  }

  void onChangedSliderStart() {
    _isSliderMoving = true;
  }

  onChangedSlider(double v) {
    _sliderPosition.value = Duration(seconds: v.floor());
  }

  void onChangedSliderEnd() {
    _isSliderMoving = false;
  }

  /// set the video player to mute or sound
  ///
  /// [enabled] if is true the video player is muted
  Future<void> setMute(bool enabled) async {
    if (enabled) {
      _volumeBeforeMute = _videoPlayerController!.value.volume;
    }
    _mute.value = enabled;
    await setVolume(enabled ? 0 : _volumeBeforeMute);
  }

  /// fast Forward (10 seconds)
  Future<void> fastForward() async {
    final to = position.value.inSeconds + 10;
    if (duration.value.inSeconds > to) {
      await seekTo(Duration(seconds: to));
    }
  }

  /// rewind (10 seconds)
  Future<void> rewind() async {
    final to = position.value.inSeconds - 10;
    await seekTo(Duration(seconds: to < 0 ? 0 : to));
  }

  Future<void> getCurrentBrightness() async {
    if (!windows) {
      try {
        _currentBrightness.value = await ScreenBrightness().current;
      } catch (e) {
        print(e);
        throw 'Failed to get current brightness';
        //return 0;
      }
    }
    //return 0;
  }

  Future<void> getCurrentVolume() async {
    if (!windows) {
      try {
        _currentVolume.value = await VolumeController().getVolume();
      } catch (e) {
        print("currentVolume " + e.toString());
        //throw 'Failed to get current brightness';
        //return 0;
      }
    }
    //return 0;
  }

  Future<void> setBrightness(double brightnes) async {
    if (!windows) {
      try {
        brightness.value = brightnes;
        ScreenBrightness().setScreenBrightness(brightnes);
        setUserPreferenceForBrightness();
      } catch (e) {
        print(e);
        throw 'Failed to set brightness';
      }
    }
  }

  /// Sets the audio volume
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volumeNew) async {
    //assert(volumeNew >= 0.0 && volumeNew <= 1.0); // validate the param
    try {
      volume.value = volumeNew;
      VolumeController().setVolume(volumeNew, showSystemUI: false);
    } catch (_) {
      print(_);
    }

    //await _videoPlayerController?.setVolume(volume);
  }

  Future<void> resetBrightness() async {
    if (!windows) {
      try {
        await ScreenBrightness().resetScreenBrightness();
      } catch (e) {
        print(e);
        throw 'Failed to reset brightness';
      }
    }
  }

  /// show or hide the player controls
  set controls(bool visible) {
    //print("controls called");
    if (fullscreen.value) {
      //print("Closed");
      screenManager.setOverlays(visible);
    }
    //print(visible);
    _showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      _hideTaskControls();
    }
  }

  /// create a tasks to hide controls after certain time
  void _hideTaskControls() {
    //print("_hideTaskControls called");
    if (windows) {
      _timer = Timer(const Duration(seconds: 2), () {
        controls = false;
        //_timer = null;
        swipeDuration.value = 0;
        showSwipeDuration.value = false;
        mouseMoveInitial = 0;
      });
    } else {
      _timer = Timer(const Duration(seconds: 5), () {
        print("hidden");
        controls = false;
        //_timer = null;
        swipeDuration.value = 0;
        showSwipeDuration.value = false;
      });
    }
  }

  /// show the player in fullscreen mode
  Future<void> goToFullscreen(
    BuildContext context, {
    bool applyOverlaysAndOrientations = true,
  }) async {
    if (applyOverlaysAndOrientations) {
      if (UniversalPlatform.isWeb) {
        screenManager.setWebFullScreen(true, this);
      } else {
        if (windows) {
          screenManager.setWindowsFullScreen(true, this);
        } else {
          screenManager.setDefaultOverlaysAndOrientations();
        }
      }
    }
    _fullscreen.value = true;
    final route = MaterialPageRoute(
      builder: (_) {
        return MeeduPlayerFullscreenPage(controller: this);
      },
    );

    await Navigator.push(context, route);
  }

  /// launch a video using the fullscreen apge
  ///
  /// [dataSource]
  /// [autoplay]
  /// [looping]
  Future<void> launchAsFullscreen(
    BuildContext context, {
    required DataSource dataSource,
    bool autoplay = false,
    bool looping = false,
    Widget? header,
    Widget? bottomRight,
    Duration seekTo = Duration.zero,
  }) async {
    this.header = header;
    this.bottomRight = bottomRight;
    setDataSource(
      dataSource,
      autoplay: autoplay,
      looping: looping,
      seekTo: seekTo,
    );
    if (windows) {
      registerHotKeys();
    }
    if (!windows) {
      getUserPreferenceForBrightness();
    }
    await goToFullscreen(context);
  }

  /// dispose de video_player controller
  Future<void> dispose([AsyncCallback? restoreHotkeysCallback]) async {
    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    videoFitChangedTimer?.cancel();

    _position.close();
    _playerEventSubs?.cancel();
    _sliderPosition.close();
    _duration.close();
    _buffered.close();
    _closedCaptionEnabled.close();
    _mute.close();
    _fullscreen.close();
    _showControls.close();
    if (windows && !UniversalPlatform.isWeb) {
      HotKeyManager.instance
          .unregisterAll()
          .then((value) => restoreHotkeysCallback?.call());
    }
    playerStatus.status.close();
    dataStatus.status.close();

    _videoPlayerController?.removeListener(_listener);
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  /// enable or diable the visibility of ClosedCaptionFile
  void onClosedCaptionEnabled(bool enabled) {
    _closedCaptionEnabled.value = enabled;
  }

  Future<void> setUserPreferenceForFit() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setString('fit', _videoFit.value.name);
  }

  Future<void> getUserPreferenceForFit() async {
    prefs = await SharedPreferences.getInstance();
    String fitValue = (await prefs?.getString('fit')) ?? "fill";
    _videoFit.value = fits.firstWhere((element) => element.name == fitValue);
    print("Last fit used was ${_videoFit.value.name}");
  }

  Future<void> setUserPreferenceForBrightness() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setDouble('brightness', brightness.value);
  }

  Future<void> getUserPreferenceForBrightness() async {
    prefs = await SharedPreferences.getInstance();
    double BrightnessValue = (await prefs?.getDouble('brightness')) ?? 0.5;
    setBrightness(BrightnessValue);
    print("Last Brightness used was ${BrightnessValue}");
  }

  /// Toggle Change the videofit accordingly
  void toggleVideoFit() {
    videoFitChangedTimer?.cancel();
    videoFitChanged.value = true;
    if (fits.indexOf(_videoFit.value) < fits.length - 1) {
      _videoFit.value = fits[fits.indexOf(_videoFit.value) + 1];
    } else {
      _videoFit.value = fits[0];
    }
    print(_videoFit.value);
    videoFitChangedTimer = Timer(const Duration(seconds: 1), () {
      print("hidden videoFit Changed");
      //videoFitChangedTimer = null;
      videoFitChanged.value = false;
      setUserPreferenceForFit();
    });
  }

  /// Change Video Fit accordingly
  void onVideoFitChange(BoxFit fit) {
    _videoFit.value = fit;
  }

  /// enter to picture in picture mode only Android
  ///
  /// only available since Android 7
  /*Future<void> enterPip(BuildContext context) async {
    if (this.pipAvailable.value && this.pipEnabled) {
      controls = false; // hide the controls
      if (!fullscreen.value) {
        // if the player is not in the fullscreen mode
        _pipContextToFullscreen = context;
        goToFullscreen(context, appliyOverlaysAndOrientations: false);
      }
      await _pipManager.enterPip();
    }
  }*/
  Future<void> videoSeekToNextSeconds(int seconds, bool playing) async {
    int position = 0;

    position = _videoPlayerController!.value.position.inSeconds;

    await seekTo(Duration(seconds: position + seconds));
    if (playing) {
      await play();
    }
    //
  }
  /*
  ///// listener for pip changes

  void _onPipModeChanged(bool isInPipMode) {
    // if the pip mode was closed and before enter to pip mode the player was not in fullscreen
    if (!isInPipMode && _pipContextToFullscreen != null) {
      Navigator.pop(_pipContextToFullscreen!); // close the fullscreen
      _pipContextToFullscreen = null;
    }
  }*/

  Future<void> videoPlayerClosed(
      [AsyncCallback? restoreHotkeysCallback]) async {
    print("Video player closed");
    fullscreen.value = false;
    resetBrightness();

    if (UniversalPlatform.isWeb) {
      screenManager.setWebFullScreen(false, this);
    } else {
      if (windows) {
        screenManager.setWindowsFullScreen(false, this);
        HotKeyManager.instance
            .unregisterAll()
            .then((value) => restoreHotkeysCallback?.call());
      } else {
        screenManager.setDefaultOverlaysAndOrientations();
      }
    }

    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    videoFitChangedTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _position.value = Duration.zero;
      _timer?.cancel();
      pause();
      Wakelock.disable();

      _videoPlayerController?.removeListener(_listener);
      await _videoPlayerController?.dispose();
      _videoPlayerController = null;

      //disposeVideoPlayerController();
      if (onVideoPlayerClosed != null) {
        print("Called");
        onVideoPlayerClosed!();
      } else {
        print("Didnt get Called");
      }
    });
  }

  static MeeduPlayerController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MeeduPlayerProvider>()!
        .controller;
  }
}
