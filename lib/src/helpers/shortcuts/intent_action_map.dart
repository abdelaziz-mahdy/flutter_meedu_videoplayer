import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter/services.dart';

Map<ShortcutActivator, void Function()> activatorsToCallBacks(
    MeeduPlayerController controller, BuildContext context) {
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
      controller.setFullScreen(false, context);
    },
    const SingleActivator(LogicalKeyboardKey.enter): () {
      if (!controller.enabledControls.enterKeyOpensFullScreen) {
        return;
      }
      controller.toggleFullScreen(context);
    },
    const SingleActivator(LogicalKeyboardKey.space): () {
      if (!controller.enabledControls.spaceKeyTogglePlay) {
        return;
      }
      controller.togglePlay();
    },
    const SingleActivator(LogicalKeyboardKey.numpadDecimal): () {
      if (!controller.enabledControls.numPadDecimalKeyToggleFit) {
        return;
      }
      controller.toggleVideoFit();
    }
  };
}
