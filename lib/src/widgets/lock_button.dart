import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';

class LockButton extends StatelessWidget {
  final Responsive responsive;
  const LockButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return RxBuilder(
        // observables: [
        //   _.lockAvailable,
        // ],
        (__) {
      _.lockedControls
          .value; // this is the value that the rxbuilder will listen to (for updates)
      if (UniversalPlatform.isDesktopOrWeb) return Container();
      String iconPath = 'assets/icons/lock-screen.png';
      Widget? customIcon = _.customIcons.lock;
      if (!_.lockedControls.value) {
        iconPath = 'assets/icons/exit_lock-screen.png';
        customIcon = _.customIcons.unlock;
      }
      return PlayerButton(
        size: responsive.buttonSize(),
        circle: false,
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
        iconPath: iconPath,
        customIcon: customIcon,
        onPressed: () => _.lockedControls.value
            ? _.toggleLockScreenMobile()
            : _.toggleLockScreenMobile(),
      );
    });
  }
}
