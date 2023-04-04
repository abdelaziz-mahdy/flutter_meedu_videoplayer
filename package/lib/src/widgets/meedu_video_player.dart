import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/secondary/secondary_player_controls.dart';
import '../helpers/shortcuts/intent_action_map.dart';

import 'closed_caption_view.dart';

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    // customDebugPrint('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

class MeeduVideoPlayer extends StatefulWidget {
  final MeeduPlayerController controller;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? header;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? bottomRight;

  final CustomIcons Function(
    Responsive responsive,
  )? customIcons;

  const MeeduVideoPlayer({
    Key? key,
    required this.controller,
    this.header,
    this.bottomRight,
    this.customIcons,
  }) : super(key: key);

  @override
  _MeeduVideoPlayerState createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: activatorsToCallBacks(widget.controller),
      child: Focus(
        autofocus: true,
        child: MeeduPlayerProvider(
          controller: widget.controller,
          child: Container(
              color: Colors.black,
              width: 0.0,
              height: 0.0,
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  MeeduPlayerController _ = widget.controller;
                  final responsive = Responsive(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  if (widget.customIcons != null) {
                    _.customIcons = widget.customIcons!(responsive);
                  }

                  if (widget.header != null) {
                    _.header = widget.header!(context, _, responsive);
                  }

                  if (widget.bottomRight != null) {
                    _.bottomRight = widget.bottomRight!(context, _, responsive);
                  }

                  return ExcludeFocus(
                    excluding: _.excludeFocus,
                    child: Stack(
                      // clipBehavior: Clip.hardEdge,
                      // fit: StackFit.loose,
                      alignment: Alignment.center,
                      children: [
                        RxBuilder(
                            //observables: [_.videoFit],
                            (__) {
                          _.dataStatus.status.value;
                          _.customDebugPrint(
                              "Fit is ${widget.controller.videoFit.value}");
                          // customDebugPrint(
                          //     "constraints.maxWidth ${constraints.maxWidth}");
                          // customDebugPrint(
                          //     "width ${_.videoPlayerController?.value.size.width}");
                          // customDebugPrint(
                          //     "videoPlayerController ${_.videoPlayerController}");
                          return Positioned.fill(
                            child: FittedBox(
                              // clipBehavior: Clip.hardEdge,
                              fit: widget.controller.videoFit.value,
                              child: SizedBox(
                                width: _.videoPlayerController != null
                                    ? _.videoPlayerController!.value.size
                                                .width !=
                                            0
                                        ? _.videoPlayerController!.value.size
                                            .width
                                        : 640
                                    : 640,
                                height: _.videoPlayerController != null
                                    ? _.videoPlayerController!.value.size
                                                .height !=
                                            0
                                        ? _.videoPlayerController!.value.size
                                            .height
                                        : 480
                                    : 480,
                                // width: 640,
                                // height: 480,
                                child: _.videoPlayerController != null
                                    ? VideoPlayer(_.videoPlayerController!)
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                        ClosedCaptionView(responsive: responsive),
                        if (_.controlsEnabled &&
                            _.controlsStyle == ControlsStyle.primary)
                          PrimaryVideoPlayerControls(
                            responsive: responsive,
                          ),
                        if (_.controlsEnabled &&
                            _.controlsStyle == ControlsStyle.secondary)
                          SecondaryVideoPlayerControls(
                            responsive: responsive,
                          ),
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MeeduPlayerProvider extends InheritedWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
