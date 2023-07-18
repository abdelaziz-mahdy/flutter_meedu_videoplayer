import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class CustomCallbacks {
  /// Callback for mobile: Triggered when a long press starts, typically used for speeding up the video.
  final void Function(MeeduPlayerController controller)?
      onLongPressStartedCallback;

  /// Callback for mobile: Triggered when a long press ends, typically used for slowing down the video.
  final void Function(MeeduPlayerController controller)?
      onLongPressEndedCallback;

  const CustomCallbacks({
    this.onLongPressStartedCallback,
    this.onLongPressEndedCallback,
  });

  CustomCallbacks copyWith({
    void Function(MeeduPlayerController controller)? onLongPressStartedCallback,
    void Function(MeeduPlayerController controller)? onLongPressEndedCallback,
  }) {
    return CustomCallbacks(
      onLongPressStartedCallback:
          onLongPressStartedCallback ?? this.onLongPressStartedCallback,
      onLongPressEndedCallback:
          onLongPressEndedCallback ?? this.onLongPressEndedCallback,
    );
  }
}
