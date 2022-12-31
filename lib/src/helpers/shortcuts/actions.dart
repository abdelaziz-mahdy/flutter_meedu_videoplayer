import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'intents.dart';

class IncreaseVolumeAction extends Action<IncreaseVolumeIntent> {
  MeeduPlayerController controller;
  IncreaseVolumeAction(this.controller);

  @override
  Object? invoke(covariant IncreaseVolumeIntent intent) {
    controller.setVolume(controller.volume.value + 0.05);
    return null;
  }
}

class DecreaseVolumeAction extends Action<DecreaseVolumeIntent> {
  MeeduPlayerController controller;
  DecreaseVolumeAction(this.controller);

  @override
  Object? invoke(covariant DecreaseVolumeIntent intent) {
    controller.setVolume(controller.volume.value - 0.05);
    return null;
  }
}

class SeekForwardAction extends Action<SeekForwardIntent> {
  MeeduPlayerController controller;
  SeekForwardAction(this.controller);

  @override
  Object? invoke(covariant SeekForwardIntent intent) {
    controller.seekTo(controller.position.value + const Duration(seconds: 5));
    return null;
  }
}

class SeekBackwardAction extends Action<SeekBackwardIntent> {
  MeeduPlayerController controller;
  SeekBackwardAction(this.controller);

  @override
  Object? invoke(covariant SeekBackwardIntent intent) {
    controller.seekTo(controller.position.value - const Duration(seconds: 5));
    return null;
  }
}

class CloseFullScreenAction extends Action<CloseFullScreenIntent> {
  MeeduPlayerController controller;
  CloseFullScreenAction(this.controller);

  @override
  Object? invoke(covariant CloseFullScreenIntent intent) {
    controller.screenManager.setWindowsFullScreen(false, controller);
    return null;
  }
}

class OpenFullScreenAction extends Action<OpenFullScreenIntent> {
  MeeduPlayerController controller;
  OpenFullScreenAction(this.controller);

  @override
  Object? invoke(covariant OpenFullScreenIntent intent) {
    controller.screenManager
        .setWindowsFullScreen(!controller.fullscreen.value, controller);

    return null;
  }
}

class TogglePlayingStateAction extends Action<TogglePlayingStateIntent> {
  MeeduPlayerController controller;
  TogglePlayingStateAction(this.controller);

  @override
  Object? invoke(covariant TogglePlayingStateIntent intent) {
    if (controller.playerStatus.playing) {
      controller.pause();
    } else {
      controller.play();
    }
    return null;
  }
}

class ToggleVideoFitAction extends Action<ToggleVideoFitIntent> {
  MeeduPlayerController controller;
  ToggleVideoFitAction(this.controller);

  @override
  Object? invoke(covariant ToggleVideoFitIntent intent) {
    controller.toggleVideoFit();
    return null;
  }
}
