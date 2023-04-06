import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'intents.dart';
import 'actions.dart';
import 'package:flutter/services.dart';

Map<Type, Action<Intent>> shortCutActions(MeeduPlayerController controller) {
  return {
    IncreaseVolumeIntent: IncreaseVolumeAction(controller),
    DecreaseVolumeIntent: DecreaseVolumeAction(controller),
    SeekForwardIntent: SeekForwardAction(controller),
    SeekBackwardIntent: SeekBackwardAction(controller),
    CloseFullScreenIntent: CloseFullScreenAction(controller),
    OpenFullScreenIntent: OpenFullScreenAction(controller),
    TogglePlayingStateIntent: TogglePlayingStateAction(controller),
    ToggleVideoFitIntent: ToggleVideoFitAction(controller),
  };
}

Map<ShortcutActivator, void Function()> activatorsToCallBacks(
    MeeduPlayerController controller) {
  return {
    const SingleActivator(LogicalKeyboardKey.arrowUp): () {
      if (!controller.enabledControls.volumeArrows) {
        return;
      }
      controller.setVolume(controller.volume.value + 0.05);
    },
    const SingleActivator(LogicalKeyboardKey.arrowDown): () {
      if (!controller.enabledControls.volumeArrows) {
        return;
      }
      controller.setVolume(controller.volume.value - 0.05);
    },
    const SingleActivator(LogicalKeyboardKey.arrowRight): () {
      if (!controller.enabledControls.seekArrows) {
        return;
      }
      controller.seekTo(controller.position.value + const Duration(seconds: 5));
    },
    const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
      if (!controller.enabledControls.seekArrows) {
        return;
      }
      controller.seekTo(controller.position.value - const Duration(seconds: 5));
    },
    const SingleActivator(LogicalKeyboardKey.escape): () {
      if (!controller.enabledControls.escapeKeyCloseFullScreen) {
        return;
      }
      controller.screenManager.setWindowsFullScreen(false, controller);
    },
    const SingleActivator(LogicalKeyboardKey.enter): () {
      if (!controller.enabledControls.enterKeyOpensFullScreen) {
        return;
      }
      controller.screenManager
          .setWindowsFullScreen(!controller.fullscreen.value, controller);
    },
    const SingleActivator(LogicalKeyboardKey.space): () {
      if (!controller.enabledControls.spaceKeyTogglePlay) {
        return;
      }
      if (controller.playerStatus.playing) {
        controller.pause();
      } else {
        controller.play();
      }
    },
    const SingleActivator(LogicalKeyboardKey.numpadDecimal): () {
      if (!controller.enabledControls.numPadDecimalKeyToggleFit) {
        return;
      }
      controller.toggleVideoFit();
    }
  };
}
