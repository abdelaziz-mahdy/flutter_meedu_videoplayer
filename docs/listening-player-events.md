# Listening the player events

To listen some events like loading, error, playing, paused, finished, etc. You can listen the stream events.

For example to keep the screen on when the video player is playing a video

```dart
  StreamSubscription _playerEventSubs;
  .
  .
  .
  // in your initState or any other method
  _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();// keep the screen on
        } else { // if the video is finished or paused
          Wakelock.disable();
        }
      },
    );
    .
    .
    .
    // DON'T FORGET CANCEL YOUR SUBSCRIPTIONS
    @override
    void dispose() {
        // The next line disables the wakelock again.
        _playerEventSubs?.cancel();
        Wakelock.disable();// if you are using wakelock
        _meeduPlayerController.dispose();
        super.dispose();
    }
```

## Streams

- `Stream<DataStatus> onDataStatusChanged`
  Stream to listen changes in the `dataSource` as **none, loading, loaded**, or **error**.

- `Stream<PlayerStatus> onPlayerStatusChanged`
  Stream to listen changes in the player as **playing, paused**, or **stopped**.

- `Stream<Duration> onPositionChanged`
  Stream to listen the video position

- `Stream<Duration> onDurationChanged`
  Stream to listen the video duration

- `Stream<bool> onFullscreenChanged`
  Stream to listen when the player enters or exits from fullscreen

- `Stream<bool> onShowControlsChanged`
  Stream to listen when the controls are visible or hidden
