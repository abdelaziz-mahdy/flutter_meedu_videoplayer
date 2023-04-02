/// this class helps you to hide some player buttons
class EnabledControls {
  final bool seekSwipes, volumeSwipes,doubleTapToSeek,desktopDoubleTapToFullScreen;

  const EnabledControls({
    this.seekSwipes = true,
    this.volumeSwipes=true,
    this.doubleTapToSeek=true,
    this.desktopDoubleTapToFullScreen=true
  });
}
