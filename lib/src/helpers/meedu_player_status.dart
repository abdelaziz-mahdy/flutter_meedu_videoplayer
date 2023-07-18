import 'package:flutter_meedu/meedu.dart';

enum PlayerStatus { completed, playing, paused }

class MeeduPlayerStatus {
  Rx<PlayerStatus> status = Rx(PlayerStatus.paused);

  bool get playing {
    return status.value == PlayerStatus.playing;
  }

  bool get paused {
    return status.value == PlayerStatus.paused;
  }

  bool get completed {
    return status.value == PlayerStatus.completed;
  }
}
