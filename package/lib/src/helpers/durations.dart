/// Defines the animation durations for various animations in a video.
///
class Durations {
  /// The duration for showing and hiding the video fit overlay.
  final Duration videoFitOverlayDuration;

  /// The duration for showing and hiding the volume overlay.
  final Duration volumeOverlayDuration;

  /// The duration for showing and hiding the playback controls.
  final Duration controlsDuration;

  /// The duration after which the controls should be automatically hidden.
  final Duration controlsAutoHideDuration;

  /// The duration for showing and hiding the brightness overlay.
  final Duration brightnessOverlayDuration;

  /// The duration for seeking forward or backward in the video or audio player.
  final Duration seekDuration;

  /// Creates a new instance of the Durations class with the specified durations.
  const Durations({
    this.videoFitOverlayDuration = const Duration(milliseconds: 250),
    this.volumeOverlayDuration = const Duration(milliseconds: 250),
    this.controlsDuration = const Duration(milliseconds: 250),
    this.controlsAutoHideDuration = const Duration(milliseconds: 1500),
    this.brightnessOverlayDuration = const Duration(milliseconds: 250),
    this.seekDuration = const Duration(milliseconds: 250),
  });
}
