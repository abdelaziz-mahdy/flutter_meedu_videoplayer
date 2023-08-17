import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu_media_kit/src/helpers/desktop_pip_bk.dart';
import 'package:flutter_meedu_media_kit/src/native/pip_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

/// An enumeration of the different styles that can be applied to controls, such
/// as buttons and icons and layouts.
enum ControlsStyle {
  primary,

  /// When a video is inserted into a scrollable list, the scroll functionality
  /// is disabled due to the drag event.
  /// To address this, I added a style to the default controller to allow scrolling.
  /// prevent drag event for scrollable list
  primaryList,
  secondary,

  /// The custom style is used to apply a custom style which you can provide in MeeduPlayerController.
  custom,
}

class MeeduPlayerController {
  /// the video_player controller
  Player? _videoPlayerController;

  /// the video_player controller
  VideoController? _videoController;

  final _pipManager = PipManager();

  StreamSubscription? _playerEventSubs;

  /// Screen Manager to define the overlays and device orientation when the player enters in fullscreen mode
  final ScreenManager screenManager;

  /// use this class to change the default icons with your custom icons
  CustomIcons customIcons;

  /// use this class to hide some buttons in the player
  EnabledButtons enabledButtons;

  /// use this class to disable controls in the player
  EnabledControls enabledControls;

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
  Widget? loadingWidget, header, bottomRight, customControls, videoOverlay;

  ///[customCaptionView] when a custom view for the captions is needed
  Widget Function(BuildContext context, MeeduPlayerController controller,
      Responsive responsive, String text)? customCaptionView;
  final ControlsStyle controlsStyle;
  final bool pipEnabled;

  String? tag;

  // OBSERVABLES
  final Rx<Duration> _position = Rx(Duration.zero);
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  final Rx<Duration> _duration = Rx(Duration.zero);
  final Rx<Duration> _buffered = Rx(Duration.zero);

  final Rx<int> _swipeDuration = 0.obs;
  Rx<int> doubleTapCount = 0.obs;
  final Rx<double> _currentVolume = 1.0.obs;
  final Rx<double> _playbackSpeed = 1.0.obs;
  final Rx<double> _currentBrightness = 0.0.obs;
  Rx<double> bufferedPercent = Rx(0.0);
  final Rx<bool> _closedCaptionEnabled = false.obs;
  final Rx<bool> _mute = false.obs;
  final Rx<bool> _fullscreen = false.obs;
  final Rx<bool> _pipAvailable = false.obs;

  final Rx<bool> _showControls = true.obs;
  final Rx<bool> _showSwipeDuration = false.obs;
  final Rx<bool> _showVolumeStatus = false.obs;
  final Rx<bool> _showBrightnessStatus = false.obs;
  Rx<bool> bufferingVideoDuration = false.obs;

  Rx<bool> videoFitChanged = false.obs;
  final Rx<BoxFit> _videoFit;

  final Rx<bool> forceUIRefreshAfterFullScreen = false.obs;

  //Rx<double> scale = 1.0.obs;
  Rx<bool> rewindIcons = false.obs;
  Rx<bool> forwardIcons = false.obs;

  // NO OBSERVABLES
  bool _isSliderMoving = false;
  bool _looping = false;
  bool _autoPlay = false;
  final bool _listenersInitialized = false;

  double _volumeBeforeMute = 0;
  double mouseMoveInitial = 0;
  Timer? _timer;
  Timer? _timerForSeek;
  Timer? _timerForCheckingSeek;

  Timer? _timerForVolume;
  Timer? _timerForShowingVolume;
  Timer? _timerForGettingVolume;
  Timer? timerForTrackingMouse;
  Timer? videoFitChangedTimer;
  RxReaction? _pipModeWorker;
  BuildContext? _pipContextToFullscreen;

  void Function()? onVideoPlayerClosed;
  List<BoxFit> fits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitHeight,
    BoxFit.fitWidth,
    BoxFit.scaleDown
  ];

  /// use this stream to listen the player data events like none, loading, loaded, error
  Stream<DataStatus> get onDataStatusChanged => dataStatus.status.stream;

  /// use this stream to listen the player data events like completed, playing, paused
  Stream<PlayerStatus> get onPlayerStatusChanged => playerStatus.status.stream;

  /// current position of the player
  Rx<Duration> get position => _position;

  /// use this stream to listen the changes in the video position
  Stream<Duration> get onPositionChanged => _position.stream;

  /// duration of the video
  Rx<Duration> get duration => _duration;

  /// use this stream to listen the changes in the video duration
  Stream<Duration> get onDurationChanged => _duration.stream;

  /// duration of the video buffered
  Rx<Duration> get buffered => _buffered;

  /// use this stream to listen the changes in the video buffered
  Stream<Duration> get onBufferedChanged => _buffered.stream;

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

  /// [brightness] is true if the player controls are visible
  Rx<double> get brightness => _currentBrightness;
  Stream<double> get onBrightnessChanged => _currentBrightness.stream;

  /// [sliderPosition] the video slider position
  Rx<Duration> get sliderPosition => _sliderPosition;
  Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  /// [videoPlayerController] instace of Player
  Player? get videoPlayerController => _videoPlayerController;

  /// [videoController] instace of Player
  VideoController? get videoController => _videoController;

  /// the playback speed default value is 1.0
  double get playbackSpeed => _playbackSpeed.value;

  /// [looping] is true if the player is looping
  bool get looping => _looping;

  /// [autoPlay] is true if the player has enabled the autoplay
  bool get autoplay => _autoPlay;

  Rx<bool> get closedCaptionEnabled => _closedCaptionEnabled;
  Stream<bool> get onClosedCaptionEnabledChanged =>
      _closedCaptionEnabled.stream;

  /// for defining that video player is working on desktop or web
  bool desktopOrWeb = false;

  /// for defining that video player needs mobile controls (even if its running on a web on a mobile device)
  bool mobileControls = false;

  /// for defining that video player locked controls
  final Rx<bool> _lockedControls = false.obs;

  /// if the player should automatically hide the controls
  final bool autoHideControls;

  /// controls if widgets inside videoplayer should get focus or not
  final bool excludeFocus;

  ///if the player should use wakelock_plus
  final bool manageWakeLock;

  /// if the player should manage Brightness
  final bool manageBrightness;

  /// if the player should show Logs
  final bool showLogs;

  /// stores the launch state
  bool launchedAsFullScreen = false;

  /// [isInPipMode] is true if pip mode is enabled
  Rx<bool> get isInPipMode => _pipManager.isInPipMode;
  Stream<bool?> get onPipModeChanged => _pipManager.isInPipMode.stream;

  Rx<bool> isBuffering = false.obs;

  SharedPreferences? prefs;

  DesktopPipBk? _desktopPipBk;
  Size? _screenSizeBk;

  // returns the os version
  Future<double> get osVersion async {
    return _pipManager.osVersion;
  }

  /// returns true if the pip mode can used on the current device, the initial value will be false after check if pip is available
  Rx<bool> get pipAvailable => _pipAvailable;

  /// return fit of the Video,By default it is set to [BoxFit.contain]
  Rx<BoxFit> get videoFit => _videoFit;

  /// returns true if the pip mode can used on the current device, the initial value will be false after check if pip is available
  Rx<bool> get lockedControls => _lockedControls;

  /// A utility class that helps make the UI responsive by defining the size of
  /// icons, buttons, and text relative to the screen size.
  /// if null default values are
  ///   Responsive({
  ///  this.fontSizeRelativeToScreen = 2.5,
  ///  this.maxFontSize = 16,
  ///  this.iconsSizeRelativeToScreen = 7,
  ///  this.maxIconsSize = 40,
  ///  this.buttonsSizeRelativeToScreen = 8,
  ///  this.maxButtonsSize = 40,
  ///});
  Responsive responsive = Responsive();

  /// Defines the animation durations for various animations in a video.
  ///
  /// This class allows you to customize the duration of animations within the video player,
  /// such as fade-in and fade-out durations, overlay show/hide animations, and more.
  /// By modifying these durations, you can adjust the visual appearance and behavior
  /// of the video player's animations according to your preferences.
  final Durations durations;

  /// Controls the visibility of player overlays.
  ///
  /// Use this class to enable or disable the visibility of player overlays, such as
  /// volume and brightness.
  final EnabledOverlays enabledOverlays;

  /// Provides custom callback functions for specific player interactions.
  ///
  /// This class allows you to specify custom callback functions for player
  /// interactions, such as long press events
  final CustomCallbacks customCallbacks;

  /// creates an instance of [MeeduPlayerController]
  ///
  /// [screenManager] the device orientations and overlays
  /// [controlsEnabled] if the player must show the player controls
  /// [manageWakeLock] if the player should use wakelock_plus
  /// [errorText] message to show when the load process failed
  MeeduPlayerController({
    this.screenManager = const ScreenManager(),
    this.colorTheme = Colors.redAccent,
    Widget? loadingWidget,
    this.controlsEnabled = true,
    this.manageWakeLock = true,
    this.manageBrightness = true,
    this.showLogs = true,
    this.excludeFocus = true,
    this.autoHideControls = true,
    String? errorText,
    this.controlsStyle = ControlsStyle.primary,
    this.header,
    this.bottomRight,
    this.fits = const [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown
    ],
    this.pipEnabled = false,
    this.customIcons = const CustomIcons(),
    this.enabledButtons = const EnabledButtons(),
    this.enabledControls = const EnabledControls(),
    this.enabledOverlays = const EnabledOverlays(),
    this.customCallbacks = const CustomCallbacks(),
    Responsive? responsive,
    this.durations = const Durations(),
    this.onVideoPlayerClosed,
    BoxFit? initialFit,
  }) : _videoFit = Rx(initialFit ?? BoxFit.fill) {
    if (responsive != null) {
      this.responsive = responsive;
    }

    if (!manageBrightness) {
      enabledControls = enabledControls.copyWith(brightnessSwipes: false);
    }

    if (initialFit == null) {
      getUserPreferenceForFit();
    }

    _errorText = errorText;
    tag = DateTime.now().microsecondsSinceEpoch.toString();
    this.loadingWidget = loadingWidget ??
        SpinKitWave(
          size: 30,
          color: colorTheme,
        );
    if ((UniversalPlatform.isWindows ||
        UniversalPlatform.isLinux ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isWeb)) {
      desktopOrWeb = true;
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      mobileControls = true;
    }

    //check each
    if (!desktopOrWeb && enabledControls.volumeSwipes) {
      VolumeController().listener((newVolume) {
        volume.value = newVolume;
      });
    }

    _playerEventSubs = onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          if (manageWakeLock) {
            WakelockPlus.enable();
          }
        } else {
          if (manageWakeLock) {
            WakelockPlus.disable();
          }
        }
      },
    );

    _pipAvailable.value = false;
    if (pipEnabled) {
      if (UniversalPlatform.isAndroid) {
        // get the OS version and check if pip is available
        _pipManager.checkPipAvailable().then(
              (value) => _pipAvailable.value = value,
            );
        // listen the pip mode changes
        _pipModeWorker = _pipManager.isInPipMode.ever(_onPipModeChanged);
      } else if (UniversalPlatform.isDesktop) {
        _pipAvailable.value = true;
      }
    }
  }

  /// create a new video_player controller
  Future<Player> _createVideoController(DataSource dataSource) async {
    Player player = _videoPlayerController ??
        Player(
            configuration: const PlayerConfiguration(
                //logLevel: logLevel
                )); // create a new video controller

    // (player.platform as libmpvPlayer).setProperty("demuxer-lavf-o", "protocol_whitelist=[file,tcp,tls,http,https]");

    _videoController = _videoController ?? VideoController(player);
    player.setPlaylistMode(PlaylistMode.loop);

    //dataSource = await checkIfm3u8AndNoLinks(dataSource);
    if (dataSource.type == DataSourceType.asset) {
      final assetUrl = dataSource.source!.startsWith("asset://")
          ? dataSource.source!
          : "asset://${dataSource.source!}";
      player.open(Media(assetUrl, httpHeaders: dataSource.httpHeaders),
          play: false
          // autoStart: ,
          );
    } else if (dataSource.type == DataSourceType.network) {
      player.open(
          Media(dataSource.source!, httpHeaders: dataSource.httpHeaders),
          play: false
          // autoStart: ,
          );
    } else {
      player.open(
          Media(dataSource.file!.path, httpHeaders: dataSource.httpHeaders),
          play: false
          // autoStart: ,
          );
    }
    //TODO: subtitles
    // if(){}
    return player;
  }

  void customDebugPrint(Object? object) {
    if (showLogs) {
      dev.log(object.toString(), name: "flutter_meedu_media_kit");
    }
  }

  /// initialize the video_player controller and load the data source
  Future _initializePlayer({
    Duration seekTo = Duration.zero,
  }) async {
    if (seekTo != Duration.zero) {
      customDebugPrint("Called seek function to $seekTo");
      await this.seekTo(seekTo);
    }

    // if the playbackSpeed is not the default value
    if (_playbackSpeed.value != 1.0) {
      await setPlaybackSpeed(_playbackSpeed.value);
    }

    // if (_looping) {
    //   await setLooping(_looping);
    // }

    if (_autoPlay) {
      // if the autoPlay is enabled
      await play();
    }
  }

  List<StreamSubscription> subscriptions = [];

  void startListeners() {
    subscriptions.addAll(
      [
        videoPlayerController!.stream.playing.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.playing;
          } else {
            //playerStatus.status.value = PlayerStatus.paused;
          }
        }),
        videoPlayerController!.stream.completed.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.completed;
          } else {
            //            playerStatus.status.value = PlayerStatus.playing;
          }
        }),
        videoPlayerController!.stream.position.listen((event) {
          _position.value = event;
          if (!_isSliderMoving) {
            _sliderPosition.value = event;
          }
        }),
        videoPlayerController!.stream.duration.listen((event) {
          duration.value = event;
        }),
        videoPlayerController!.stream.buffer.listen((event) {
          _buffered.value = event;
        }),
        videoPlayerController!.stream.buffering.listen((event) {
          isBuffering.value = event;
        }),
        videoPlayerController!.stream.volume.listen((event) {
          if (!mute.value && _volumeBeforeMute != event) {
            _volumeBeforeMute = event / 100;
          }
        }),
      ],
    );
  }

  void removeListeners() {
    for (final s in subscriptions) {
      s.cancel();
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
      _autoPlay = autoplay;
      _looping = looping;
      dataStatus.status.value = DataStatus.loading;

      // if we are playing a video
      if (_videoPlayerController != null &&
          _videoPlayerController!.state.playing) {
        await pause(notify: false);
      }

      _videoPlayerController = await _createVideoController(dataSource);

      // set the video duration
      customDebugPrint("Duration is ${_videoPlayerController!.state.duration}");

      _duration.value = _videoPlayerController!.state.duration;

      /// notify that video was loaded
      dataStatus.status.value = DataStatus.loaded;

      await _initializePlayer(seekTo: seekTo);
      // listen the video player events
      if (!_listenersInitialized) {
        startListeners();
      }
    } catch (e, s) {
      customDebugPrint(e);
      customDebugPrint(s);
      // _errorText ??= _videoPlayerController!.value.errorDescription ?? "$e";
      dataStatus.status.value = DataStatus.error;
    }
  }

  /// play the current video
  ///
  /// [repeat] if is true the player go to Duration.zero before play
  Future<void> play({bool repeat = false, bool hideControls = true}) async {
    if (repeat) {
      await seekTo(Duration.zero);
    }

    await _videoPlayerController?.play();
    await getCurrentVolume();
    await getCurrentBrightness();

    playerStatus.status.value = PlayerStatus.playing;
    // screenManager.setOverlays(false);
    if (hideControls && autoHideControls) {
      _hideTaskControls();
    }
    //
  }

  /// pause the current video
  ///
  /// [notify] if is true and the events is not null we notifiy the event
  Future<void> pause({bool notify = true}) async {
    await _videoPlayerController?.pause();
    playerStatus.status.value = PlayerStatus.paused;
  }

  /// toggle play the current video
  Future<void> togglePlay() async {
    if (playerStatus.playing) {
      pause();
    } else {
      play();
    }
  }

  /// seek the current video position
  Future<void> seekTo(Duration position) async {
    if (position >= duration.value) {
      position = duration.value - const Duration(milliseconds: 100);
    }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    _position.value = position;
    customDebugPrint(
        "position in seek function is ${_position.value.toString()}");
    customDebugPrint(
        "duration in seek function is ${duration.value.toString()}");

    if (duration.value.inSeconds != 0) {
      await _videoPlayerController?.seek(position);

      // if (playerStatus.stopped) {
      //   play();
      // }
    } else {
      _timerForSeek?.cancel();
      _timerForSeek =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
        //_timerForSeek = null;
        customDebugPrint("SEEK CALLED");
        if (duration.value.inSeconds != 0) {
          await _videoPlayerController?.seek(position);

          // if (playerStatus.stopped) {
          //   play();
          // }
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
    await _videoPlayerController?.setRate(speed);
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

  // /// Sets whether or not the video should loop after playing once
  // Future<void> setLooping(bool looping) async {
  //   await _videoPlayerController?.setLooping(looping);
  //   _looping = looping;
  // }

  void onChangedSliderStart() {
    _isSliderMoving = true;
    controls = true;
  }

  onChangedSlider(double v) {
    _sliderPosition.value = Duration(milliseconds: v.floor());
    controls = true;
  }

  void onChangedSliderEnd() {
    _isSliderMoving = false;
  }

  /// set the video player to mute or sound
  ///
  /// [enabled] if is true the video player is muted
  Future<void> setMute(bool enabled) async {
    if (enabled) {
      _volumeBeforeMute = _videoPlayerController!.state.volume / 100;
    }
    _mute.value = enabled;
    await setVolume(enabled ? 0 : _volumeBeforeMute, videoPlayerVolume: true);
  }

  /// fast Forward (10 seconds)
  Future<void> fastForward() async {
    await videoSeekToNextSeconds(10, playerStatus.playing);
  }

  /// rewind (10 seconds)
  Future<void> rewind() async {
    await videoSeekToNextSeconds(-10, playerStatus.playing);
  }

  Future<void> getCurrentBrightness() async {
    if (!desktopOrWeb && manageBrightness) {
      try {
        _currentBrightness.value = await ScreenBrightness().current;
      } catch (e) {
        customDebugPrint(e);
        throw 'Failed to get current brightness';
        //return 0;
      }
    }
    //return 0;
  }

  Future<void> getCurrentVolume() async {
    if (desktopOrWeb) {
      // print(
      //     "_videoPlayerController?.state.volume ${_videoPlayerController?.state.volume}");
      if ((_videoPlayerController?.state.volume ?? 0) == 1.0) {
        _currentVolume.value = (_videoPlayerController?.state.volume ?? 0);
      } else {
        _currentVolume.value =
            (_videoPlayerController?.state.volume ?? 0) / 100;
      }
    } else {
      try {
        _currentVolume.value = await VolumeController().getVolume();
      } catch (e) {
        customDebugPrint("currentVolume $e");
        //throw 'Failed to get current brightness';
        //return 0;
      }
    }
    //return 0;
  }

  Future<void> setBrightness(double brightnes) async {
    if (!manageBrightness) {
      return;
    }
    if (!desktopOrWeb) {
      try {
        brightness.value = brightnes;
        ScreenBrightness().setScreenBrightness(brightnes);
        setUserPreferenceForBrightness();
      } catch (e) {
        customDebugPrint(e);
        throw 'Failed to set brightness';
      }
    }
  }

  /// Sets the audio volume
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volumeNew,
      {bool videoPlayerVolume = false}) async {
    if (volumeNew < 0.0) {
      volumeNew = 0.0;
    } else if (volumeNew > 1.0) {
      volumeNew = 1.0;
    }
    if (volume.value == volumeNew) {
      return;
    }
    volume.value = volumeNew;

    if (desktopOrWeb || videoPlayerVolume) {
      customDebugPrint("volume is $volumeNew");
      await _videoPlayerController?.setVolume(volumeNew * 100);
      volumeUpdated();
    } else {
      try {
        VolumeController().setVolume(volumeNew, showSystemUI: false);
      } catch (_) {
        customDebugPrint(_);
      }
    }
  }

  void volumeUpdated() {
    showVolumeStatus.value = true;
    _timerForShowingVolume?.cancel();
    _timerForShowingVolume = Timer(const Duration(seconds: 1), () {
      showVolumeStatus.value = false;
    });
  }

  Future<void> resetBrightness() async {
    if (!manageBrightness) {
      return;
    }
    if (!desktopOrWeb) {
      try {
        await ScreenBrightness().resetScreenBrightness();
      } catch (e) {
        customDebugPrint(e);
        throw 'Failed to reset brightness';
      }
    }
  }

  /// show or hide the player controls
  set controls(bool visible) {
    // if (!UniversalPlatform.isDesktopOrWeb && visible && lockedControls.value) {
    //   return;
    // }

    // customDebugPrint("controls called with value $visible");
    if (fullscreen.value) {
      //customDebugPrint("Closed");
      screenManager.setOverlays(visible);
    }
    //customDebugPrint(visible);
    _showControls.value = visible;
    _timer?.cancel();
    if (visible && autoHideControls) {
      _hideTaskControls();
    }
  }

  void toggleLockScreenMobile() {
    if (!UniversalPlatform.isDesktopOrWeb) {
      _lockedControls.value = !_lockedControls.value;
    }
  }

  /// create a tasks to hide controls after certain time
  void _hideTaskControls() {
    // customDebugPrint(
    //     "controls will be hidden after ${durations.controlsAutoHideDuration}");

    _timer = Timer(durations.controlsAutoHideDuration, () {
      controls = false;
      //_timer = null;
      swipeDuration.value = 0;
      showSwipeDuration.value = false;
      mouseMoveInitial = 0;
    });
  }

  /// show the player in fullscreen mode
  Future<void> goToFullscreen(BuildContext context,
      {bool applyOverlaysAndOrientations = true,
      bool disposePlayer = false}) async {
    if (applyOverlaysAndOrientations) {
      if (UniversalPlatform.isWeb) {
        screenManager.setWebFullScreen(true, this);
      } else {
        if (desktopOrWeb) {
          if (!isInPipMode.value) {
            _screenSizeBk = await windowManager.getSize();
          }
          screenManager.setWindowsFullScreen(true, this);
        } else {
          screenManager.setFullScreenOverlaysAndOrientations();
        }
      }
    }
    setVideoAsAppFullScreen(context,
        applyOverlaysAndOrientations: applyOverlaysAndOrientations,
        disposePlayer: disposePlayer);
  }

  Future<void> setVideoAsAppFullScreen(BuildContext context,
      {bool applyOverlaysAndOrientations = true,
      bool disposePlayer = false}) async {
    _fullscreen.value = true;

    final route = PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      pageBuilder: (_, __, ___) {
        return MeeduPlayerFullscreenPage(
          controller: this,
          disposePlayer: disposePlayer,
        );
      },
    );

    await Navigator.of(context).push(route);
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
    launchedAsFullScreen = true;
    setDataSource(
      dataSource,
      autoplay: autoplay,
      looping: looping,
      seekTo: seekTo,
    );

    if (!desktopOrWeb && manageBrightness) {
      getUserPreferenceForBrightness();
    }
    await goToFullscreen(context, disposePlayer: true);
  }

  /// dispose de video_player controller
  Future<void> dispose() async {
    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    _timerForCheckingSeek?.cancel();
    videoFitChangedTimer?.cancel();
    _pipModeWorker?.dispose();
    _position.close();
    _playerEventSubs?.cancel();
    _sliderPosition.close();
    _duration.close();
    _buffered.close();
    _closedCaptionEnabled.close();
    _mute.close();
    _fullscreen.close();
    _showControls.close();

    playerStatus.status.close();
    dataStatus.status.close();

    removeListeners();
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
    String fitValue = (prefs?.getString('fit')) ?? "fill";
    _videoFit.value = fits.firstWhere((element) => element.name == fitValue);
    customDebugPrint("Last fit used was ${_videoFit.value.name}");
  }

  Future<void> setUserPreferenceForBrightness() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setDouble('brightness', brightness.value);
  }

  Future<void> getUserPreferenceForBrightness() async {
    prefs = await SharedPreferences.getInstance();
    double brightnessValue = (prefs?.getDouble('brightness')) ?? 0.5;
    setBrightness(brightnessValue);
    customDebugPrint("Last Brightness used was $brightnessValue");
  }

  /// Toggles the full-screen mode of the application window.
  ///
  /// If the current full-screen mode is `true`, sets the full-screen mode to `false`
  /// and exits the full-screen mode if necessary. Otherwise, sets the full-screen mode
  /// to `true` and enters the full-screen mode.
  ///
  /// Parameters:
  ///   - context: A `BuildContext` object used to access the current widget tree context.
  void toggleFullScreen(BuildContext context) {
    setFullScreen(!fullscreen.value, context);
  }

  /// Sets the full-screen mode of the application window.
  ///
  /// If the `fullscreen` parameter is `true`, sets the full-screen mode of the application
  /// window to `true`. Otherwise, sets the full-screen mode to `false` and exits the
  /// full-screen mode if necessary.
  ///
  /// Parameters:
  ///   - fullscreen: A boolean indicating whether the application window should be in full-screen mode.
  ///   - context: A `BuildContext` object used to access the current widget tree context.
  void setFullScreen(bool fullscreen, BuildContext context) {
    if (fullscreen) {
      goToFullscreen(context);
    } else {
      if (launchedAsFullScreen) {
        if (UniversalPlatform.isWeb) {
          screenManager.setWebFullScreen(false, this);
        } else {
          if (desktopOrWeb) {
            screenManager.setWindowsFullScreen(false, this);
          } else {
            screenManager.setDefaultOverlaysAndOrientations();
          }
        }
      } else {
        if (this.fullscreen.value) {
          Navigator.pop(context);
        }
      }
    }
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
    customDebugPrint(_videoFit.value);
    videoFitChangedTimer = Timer(const Duration(seconds: 1), () {
      customDebugPrint("hidden videoFit Changed");
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
    if (seconds == 0) {
      return;
    }
    int position = 0;

    position = _videoPlayerController!.state.position.inSeconds;

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
      Navigator.maybePop(_pipContextToFullscreen!); // close the fullscreen
      _pipContextToFullscreen = null;
    }
  }*/
  Future<void> onFullscreenClose() async {
    customDebugPrint("Fullscreen Closed");
    await resetBrightness();

    if (UniversalPlatform.isWeb) {
      await screenManager.setWebFullScreen(false, this);
    } else {
      if (desktopOrWeb) {
        await screenManager.setWindowsFullScreen(false, this);
      } else {
        await screenManager.setDefaultOverlaysAndOrientations();
      }
    }
    fullscreen.value = false;
  }

  Future<void> videoPlayerClosed() async {
    customDebugPrint("Video player closed");
    await onFullscreenClose();

    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    _timerForCheckingSeek?.cancel();
    videoFitChangedTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _position.value = Duration.zero;
      _timer?.cancel();
      pause();
      if (manageWakeLock) {
        WakelockPlus.disable();
      }

      removeListeners();
      await _videoPlayerController?.dispose();
      _videoPlayerController = null;

      //disposePlayer();
      if (onVideoPlayerClosed != null) {
        customDebugPrint("Called");
        onVideoPlayerClosed!();
      } else {
        customDebugPrint("Didnt get Called");
      }
    });
  }

  double getAspectRatio() {
    if (_videoPlayerController == null &&
        _videoPlayerController!.state.width != null &&
        _videoPlayerController!.state.height != null) {
      return 16 / 9;
    }

    return _videoPlayerController!.state.width! /
        _videoPlayerController!.state.height!;
  }

  /// enter to picture in picture mode only Android
  ///
  /// only available since Android 7
  Future<void> enterPip(BuildContext context) async {
    if (pipAvailable.value && pipEnabled) {
      if (UniversalPlatform.isAndroid) {
        await _enterPipAndroid(context);
      } else if (UniversalPlatform.isDesktop) {
        await _enterPipDesktop(context);
      }
    }
  }

  Future<void> _enterPipAndroid(BuildContext context) async {
    controls = false; // hide the controls
    if (!fullscreen.value) {
      // if the player is not in the fullscreen mode
      _pipContextToFullscreen = context;
      goToFullscreen(context, applyOverlaysAndOrientations: false);
    }
    await _pipManager.enterPip();
  }

  Future<void> _enterPipDesktop(BuildContext context) async {
    if (_videoPlayerController == null) return;
    if (!fullscreen.value) {
      setVideoAsAppFullScreen(context);
    }
    double minH = max(MediaQuery.of(context).size.height * 0.15, 200);
    double defaultH = max(MediaQuery.of(context).size.height * 0.30, 400);

    double aspectRatio = getAspectRatio();
    _desktopPipBk = DesktopPipBk(
      isFullScreen: await windowManager.isFullScreen(),
      size: await windowManager.isFullScreen()
          ? (_screenSizeBk ??
              Size(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ))
          : await windowManager.getSize(),
    );

    await onFullscreenClose();
    // ignore: use_build_context_synchronously

    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.center(animate: true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setMinimumSize(Size(minH * (aspectRatio), minH));
    await windowManager.setSize(Size(defaultH * (aspectRatio), defaultH));
    // await windowManager.setAsFrameless();
    await windowManager.setAspectRatio(aspectRatio);
    // windowManager.setSkipTaskbar(true);
    _pipManager.isInPipMode.value = true;
  }

  /// listener for pip changes
  void _onPipModeChanged(bool isInPipMode) {
    // if the pip mode was closed and before enter to pip mode the player was not in fullscreen
    if (!isInPipMode && _pipContextToFullscreen != null) {
      Navigator.pop(_pipContextToFullscreen!); // close the fullscreen
      _pipContextToFullscreen = null;
    }
  }

  void closePip(BuildContext context) {
    if (_pipManager.isInPipMode.value == true) {
      if (UniversalPlatform.isDesktop) {
        if (!_desktopPipBk!.isFullScreen) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }

        _closePipDesktop(context);
      }
    }
  }

  Future<void> _closePipDesktop(BuildContext context) async {
    double defaultSizeHeight =
        max(MediaQuery.of(context).size.height * 0.30, 300);
    double defaultSizeWidth =
        max(MediaQuery.of(context).size.width * 0.30, 500);

    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setAspectRatio(0);
    // // windowManager.setSkipTaskbar(false);
    await windowManager.setSize(_desktopPipBk!.size);
    await windowManager
        .setMinimumSize(Size(defaultSizeWidth, defaultSizeHeight));
    if (_desktopPipBk!.isFullScreen) {
      screenManager.setWindowsFullScreen(true, this);
    }
    _pipManager.isInPipMode.value = false;
  }

  static MeeduPlayerController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MeeduPlayerProvider>()!
        .controller;
  }
}
