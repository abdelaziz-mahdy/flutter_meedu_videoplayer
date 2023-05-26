/// this class helps you to hide some player buttons
class EnabledButtons {
  final bool playPauseAndRepeat,
      rewindAndfastForward,
      videoFit,
      muteAndSound,
      pip,
      fullscreen,
      playBackSpeed;

  const EnabledButtons({
    this.playPauseAndRepeat = true,
    this.rewindAndfastForward = true,
    this.videoFit = true,
    this.muteAndSound = true,
    this.pip = true,
    this.fullscreen = true,
    this.playBackSpeed = true,
  });
}
