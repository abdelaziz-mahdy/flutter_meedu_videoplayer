import 'package:flutter/material.dart';

class IncreaseVolumeIntent extends Intent {
  const IncreaseVolumeIntent();
}

class DecreaseVolumeIntent extends Intent {
  const DecreaseVolumeIntent();
}

class SeekForwardIntent extends Intent {
  const SeekForwardIntent();
}

class SeekBackwardIntent extends Intent {
  const SeekBackwardIntent();
}

class CloseFullScreenIntent extends Intent {
  const CloseFullScreenIntent();
}

class OpenFullScreenIntent extends Intent {
  const OpenFullScreenIntent();
}

class TogglePlayingStateIntent extends Intent {
  const TogglePlayingStateIntent();
}

class ToggleVideoFitIntent extends Intent {
  const ToggleVideoFitIntent();
}
