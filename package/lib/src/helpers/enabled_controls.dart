// ignore_for_file: public_member_api_docs, sort_constructors_first
/// this class helps you to hide some player buttons
class EnabledControls {
  final bool seekSwipes,
      volumeSwipes,
      doubleTapToSeek,
      desktopDoubleTapToFullScreen,
      brightnessSwipes;

  const EnabledControls(
      {this.seekSwipes = true,
      this.volumeSwipes = true,
      this.brightnessSwipes = true,
      this.doubleTapToSeek = true,
      this.desktopDoubleTapToFullScreen = true});

  EnabledControls copyWith(
      {bool? seekSwipes,
      bool? volumeSwipes,
      bool? doubleTapToSeek,
      bool? desktopDoubleTapToFullScreen,
      bool? brightnessSwipes}) {
    return EnabledControls(
      seekSwipes: seekSwipes ?? this.seekSwipes,
      volumeSwipes: volumeSwipes ?? this.volumeSwipes,
      brightnessSwipes: brightnessSwipes ?? this.brightnessSwipes,
      doubleTapToSeek: doubleTapToSeek ?? this.doubleTapToSeek,
      desktopDoubleTapToFullScreen:
          desktopDoubleTapToFullScreen ?? this.desktopDoubleTapToFullScreen,
    );
  }
}
