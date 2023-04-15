// ignore_for_file: public_member_api_docs, sort_constructors_first
/// this class helps you to hide some player buttons
class EnabledControls {
  /// on mobile, swipe horizontally to seek in video
  final bool seekSwipes;

  /// on mobile, swipe vertically to control volume (on right side)
  final bool volumeSwipes;

  /// on mobile, swipe vertically to control brightness (on left side)
  final bool brightnessSwipes;

  /// on mobile, double tap on sides to seek forward or backwards
  final bool doubleTapToSeek;

  /// on desktop, double clicks with mouse go fullScreen or close it
  final bool desktopDoubleTapToFullScreen;

  /// on desktop, one click with mouse go toggle play and pause
  final bool desktopTapToPlayAndPause;

  ///on desktop, keyboard arrows (up and down) increase and decrease volume
  final bool volumeArrows;

  ///on desktop, keyboard arrows (right and left) forward and backward seek
  final bool seekArrows;

  ///on desktop, escape closes fullScreen
  final bool escapeKeyCloseFullScreen;

  ///on desktop, numPad Decimal (.) Toggle Fit of video
  final bool numPadDecimalKeyToggleFit;

  ///on desktop, enter Key opens video fullScreen
  final bool enterKeyOpensFullScreen;

  ///on desktop, space Key toggle from playing to pause and pause to playing
  final bool spaceKeyTogglePlay;

  const EnabledControls(
      {this.desktopTapToPlayAndPause = true,
      this.escapeKeyCloseFullScreen = true,
      this.numPadDecimalKeyToggleFit = true,
      this.enterKeyOpensFullScreen = true,
      this.spaceKeyTogglePlay = true,
      this.volumeArrows = true,
      this.seekArrows = true,
      this.seekSwipes = true,
      this.volumeSwipes = true,
      this.brightnessSwipes = true,
      this.doubleTapToSeek = true,
      this.desktopDoubleTapToFullScreen = true});

  EnabledControls copyWith({
    bool? desktopTapToPlayAndPause,
    bool? seekSwipes,
    bool? volumeSwipes,
    bool? brightnessSwipes,
    bool? doubleTapToSeek,
    bool? desktopDoubleTapToFullScreen,
    bool? volumeArrows,
    bool? seekArrows,
    bool? escapeKeyCloseFullScreen,
    bool? numPadDecimalKeyToggleFit,
    bool? enterKeyOpensFullScreen,
    bool? spaceKeyTogglePlay,
  }) {
    return EnabledControls(
      desktopTapToPlayAndPause:
          desktopTapToPlayAndPause ?? this.desktopTapToPlayAndPause,
      seekSwipes: seekSwipes ?? this.seekSwipes,
      volumeSwipes: volumeSwipes ?? this.volumeSwipes,
      brightnessSwipes: brightnessSwipes ?? this.brightnessSwipes,
      doubleTapToSeek: doubleTapToSeek ?? this.doubleTapToSeek,
      desktopDoubleTapToFullScreen:
          desktopDoubleTapToFullScreen ?? this.desktopDoubleTapToFullScreen,
      volumeArrows: volumeArrows ?? this.volumeArrows,
      seekArrows: seekArrows ?? this.seekArrows,
      escapeKeyCloseFullScreen:
          escapeKeyCloseFullScreen ?? this.escapeKeyCloseFullScreen,
      numPadDecimalKeyToggleFit:
          numPadDecimalKeyToggleFit ?? this.numPadDecimalKeyToggleFit,
      enterKeyOpensFullScreen:
          enterKeyOpensFullScreen ?? this.enterKeyOpensFullScreen,
      spaceKeyTogglePlay: spaceKeyTogglePlay ?? this.spaceKeyTogglePlay,
    );
  }
}
