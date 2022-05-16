import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/secondary/secondary_player_controls.dart';

import 'closed_caption_view.dart';

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

  MeeduVideoPlayer({
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
    return MeeduPlayerProvider(
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
                _.customIcons = this.widget.customIcons!(responsive);
              }

              if (widget.header != null) {
                _.header = this.widget.header!(context, _, responsive);
              }

              if (widget.bottomRight != null) {
                _.bottomRight =
                    this.widget.bottomRight!(context, _, responsive);
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_.windows)
                    RxBuilder(
                        //observables: [_.videoFit],
                        (__) {
                      //print("NATIVE HAS BEEN REBUILT ${_.videoPlayerControllerWindows}");
                      _.dataStatus.status.value;
                      if (_.videoPlayerControllerWindows == null) {
                        return Text("Loading");
                      }

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Platform.isWindows
                              ? NativeVideo(
                                  player: _.videoPlayerControllerWindows!,
                                  showControls: false,
                                )
                              : Video(
                                  player: _.videoPlayerControllerWindows!,
                                  showControls: false,
                                ),
                        ],
                      );
                    })
                  else
                    RxBuilder(
                        //observables: [_.videoFit],
                        (__) {
                      _.dataStatus.status.value;
                      print("Fit is ${widget.controller.videoFit.value}");
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: widget.controller.videoFit.value,
                          child: SizedBox(
                            width: _.videoPlayerController != null
                                ? _.videoPlayerController!.value.size.width
                                : 640,
                            height: _.videoPlayerController != null
                                ? _.videoPlayerController!.value.size.height
                                : 480,
                            child: VideoPlayer(_.videoPlayerController!),
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
              );
            },
          )),
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

  MeeduPlayerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
