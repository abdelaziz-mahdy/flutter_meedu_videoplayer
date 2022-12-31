import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/shortcuts/actions.dart';
import 'intents.dart';
import 'package:flutter/services.dart';

Map<LogicalKeySet, Intent> shortcutsToIntents = {
  LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncreaseVolumeIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecreaseVolumeIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowRight): const SeekForwardIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowLeft): const SeekBackwardIntent(),
  LogicalKeySet(LogicalKeyboardKey.escape): const CloseFullScreenIntent(),
  LogicalKeySet(LogicalKeyboardKey.enter): const OpenFullScreenIntent(),
  LogicalKeySet(LogicalKeyboardKey.space): const TogglePlayingStateIntent(),
  LogicalKeySet(LogicalKeyboardKey.numpadDecimal): const ToggleVideoFitIntent(),
};


