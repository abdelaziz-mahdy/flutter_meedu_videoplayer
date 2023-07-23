import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/controls_container.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_list_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/secondary/secondary_player_controls.dart';
import 'package:video_player_media_kit/video_player_media_kit_platform/media_kit_theme.dart';
import '../helpers/shortcuts/intent_action_map.dart';

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

  ///[customControls] this only needed when controlsStyle is [ControlsStyle.custom]
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? customControls;

  ///[customCaptionView] when a custom view for the captions is needed
  final Widget Function(BuildContext context, MeeduPlayerController controller,
      Responsive responsive, String text)? customCaptionView;

  ///[backgroundColor] video background color
  final Color backgroundColor;

  /// The distance from the bottom of the screen to the closed captions text.
  ///
  /// This value represents the vertical position of the closed captions display
  /// from the bottom of the screen. It is measured in logical pixels and can be
  /// used to adjust the positioning of the closed captions within the video player
  /// UI. A higher value will move the closed captions higher on the screen, while
  /// a lower value will move them closer to the bottom.
  ///
  /// By adjusting this distance, you can ensure that the closed captions are
  /// displayed at an optimal position that doesn't obstruct other important
  /// elements of the video player interface.
  final double closedCaptionDistanceFromBottom;
  const MeeduVideoPlayer(
      {Key? key,
      required this.controller,
      this.header,
      this.bottomRight,
      this.customIcons,
      this.customControls,
      this.customCaptionView,
      this.closedCaptionDistanceFromBottom = 40,
      this.backgroundColor = Colors.black})
      : super(key: key);

  @override
  State<MeeduVideoPlayer> createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  // bool oldUIRefresh = false;
  ValueKey _key = const ValueKey(true);
  double videoWidth(VideoPlayerController? controller) {
    double width = controller != null
        ? controller.value.size.width != 0
            ? controller.value.size.width
            : 640
        : 640;
    return width;
    // if (width < max) {
    //   return max;
    // } else {
    //   return width;
    // }
  }

  double videoHeight(VideoPlayerController? controller) {
    double height = controller != null
        ? controller.value.size.height != 0
            ? controller.value.size.height
            : 480
        : 480;
    return height;
    // if (height < max) {
    //   return max;
    // } else {
    //   return height;
    // }
  }

  void refresh() {
    if (!kIsWeb) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _key = ValueKey(!_key.value);

        // your state update logic goes here
      });
      if (widget.controller.playerStatus.playing) {
        widget.controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: activatorsToCallBacks(widget.controller, context),
      child: Focus(
        autofocus: true,
        child: MeeduPlayerProvider(
          controller: widget.controller,
          child: MediaKitTheme(
            fillColor: widget.backgroundColor,
            child: Container(
                color: widget.backgroundColor,
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    MeeduPlayerController _ = widget.controller;
                    if (_.controlsEnabled) {
                      _.responsive.setDimensions(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                    }

                    if (widget.customIcons != null) {
                      _.customIcons = widget.customIcons!(_.responsive);
                    }

                    if (widget.header != null) {
                      _.header = widget.header!(context, _, _.responsive);
                    }

                    if (widget.bottomRight != null) {
                      _.bottomRight =
                          widget.bottomRight!(context, _, _.responsive);
                    }

                    if (widget.customControls != null) {
                      _.customControls =
                          widget.customControls!(context, _, _.responsive);
                    }
                    if (widget.customCaptionView != null) {
                      _.customCaptionView = widget.customCaptionView;
                    }
                    return ExcludeFocus(
                      excluding: _.excludeFocus,
                      child: Stack(
                        // clipBehavior: Clip.hardEdge,
                        // fit: StackFit.,
                        alignment: Alignment.center,
                        children: [
                          RxBuilder(
                              //observables: [_.videoFit],
                              (__) {
                            if (widget.controller.forceUIRefreshAfterFullScreen
                                .value) {
                              print("NEEDS TO REFRASH UI");
                              refresh();
                              widget.controller.forceUIRefreshAfterFullScreen
                                  .value = false;
                            }
                            // widget.controller.forceUIRefreshAfterFullScreen
                            //     .value = false;
                            _.dataStatus.status.value;
                            _.customDebugPrint(
                                "Fit is ${widget.controller.videoFit.value}");
                            // customDebugPrint(
                            //     "constraints.maxWidth ${constraints.maxWidth}");
                            // _.customDebugPrint(
                            //     "width ${videoWidth(_.videoPlayerController, constraints.maxWidth)}");
                            // customDebugPrint(
                            //     "videoPlayerController ${_.videoPlayerController}");
                            return Positioned.fill(
                              child: FittedBox(
                                clipBehavior: Clip.hardEdge,
                                fit: widget.controller.videoFit.value,
                                child: SizedBox(
                                  width: videoWidth(
                                    _.videoPlayerController,
                                  ),
                                  height: videoHeight(
                                    _.videoPlayerController,
                                  ),
                                  // width: 640,
                                  // height: 480,
                                  child: _.videoPlayerController != null
                                      ? VideoPlayer(
                                          _.videoPlayerController!,
                                          key: _key,
                                        )
                                      : Container(),
                                ),
                              ),
                            );
                          }),
                          ClosedCaptionView(
                            responsive: _.responsive,
                            distanceFromBottom:
                                widget.closedCaptionDistanceFromBottom,
                            customCaptionView: _.customCaptionView,
                          ),
                          if (_.controlsEnabled &&
                              _.controlsStyle == ControlsStyle.primary)
                            PrimaryVideoPlayerControls(
                              responsive: _.responsive,
                            ),
                          if (_.controlsEnabled &&
                              _.controlsStyle == ControlsStyle.primaryList)
                            PrimaryListVideoPlayerControls(
                              responsive: _.responsive,
                            ),
                          if (_.controlsEnabled &&
                              _.controlsStyle == ControlsStyle.secondary)
                            SecondaryVideoPlayerControls(
                              responsive: _.responsive,
                            ),
                          if (_.controlsEnabled &&
                              _.controlsStyle == ControlsStyle.custom &&
                              _.customControls != null)
                            ControlsContainer(
                              responsive: _.responsive,
                              child: _.customControls!,
                            )
                        ],
                      ),
                    );
                  },
                )),
          ),
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
