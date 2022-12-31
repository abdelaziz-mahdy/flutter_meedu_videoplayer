import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'intents.dart';
import 'actions.dart';

Map<Type, Action<Intent>> shortCutActions(MeeduPlayerController controller) {
  return {
    IncreaseVolumeIntent: IncreaseVolumeAction(controller),
    DecreaseVolumeIntent: DecreaseVolumeAction(controller),
    SeekForwardIntent: SeekForwardAction(controller),
    SeekBackwardIntent: SeekBackwardAction(controller),
    CloseFullScreenIntent: CloseFullScreenAction(controller),
    OpenFullScreenIntent: OpenFullScreenAction(controller),
    TogglePlayingStateIntent:TogglePlayingStateAction(controller),
    ToggleVideoFitIntent:ToggleVideoFitAction(controller),
  };
}
