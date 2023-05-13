import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class ControlsContainer extends StatefulWidget {
  final Widget child;
  final Responsive responsive;
  //Duration swipeDuration=Duration(seconds: 0);
  const ControlsContainer(
      {Key? key, required this.child, required this.responsive})
      : super(key: key);

  @override
  State<ControlsContainer> createState() => _ControlsContainerState();
}

class _ControlsContainerState extends State<ControlsContainer> {
  bool playing = false;

  bool gettingNotification = false;

  late Offset horizontalDragStartOffset;

  Offset _dragInitialDelta = Offset.zero;

  Offset _verticalDragStartOffset = Offset.zero;

  //Offset _mouseMoveInitial = Offset.zero;
  Offset _horizontalDragStartOffset = Offset.zero;

  final ValueNotifier<double> _currentVolume = ValueNotifier<double>(1.0);

  double _onDragStartVolume = 1;

  double _onDragStartBrightness = 1;

  bool isVolume = false;

  //bool gettingNotification = false;
  final int _defaultSeekAmount = -10;

  Timer? _doubleTapToSeekTimer;

  Timer? _tappedOnce;

  bool tappedTwice = false;

  final ValueNotifier<double> _currentBrightness = ValueNotifier<double>(1.0);

  //------------------------------------//
  void _forwardDragStart(
      Offset localPosition, MeeduPlayerController controller) async {
    playing = controller.playerStatus.playing;
    controller.pause();
    //_initialForwardPosition = controller.position.value;
    _horizontalDragStartOffset = localPosition;
    controller.showSwipeDuration.value = true;
  }

  void tappedOnce(MeeduPlayerController _, bool secondTap) {
    if (!secondTap) {
      //   // _tappedOnce?.cancel();
      //   _.controls = false;
      // } else {
      tappedTwice = true;
      _.controls = !_.showControls.value;
      _tappedOnce?.cancel();
      _tappedOnce = Timer(const Duration(milliseconds: 300), () {
        _.customDebugPrint("set tapped twice to false");
        tappedTwice = false;
        //_dragInitialDelta = Offset.zero;
      });
    }
  }

  void _rewind(BuildContext context, MeeduPlayerController controller) =>
      _showRewindAndForward(context, 0, controller);

  void _forward(BuildContext context, MeeduPlayerController controller) =>
      _showRewindAndForward(context, 1, controller);

  void _showRewindAndForward(
      BuildContext context, int index, MeeduPlayerController controller) async {
    //controller.videoSeekToNextSeconds(amount);
    if (index == 0) {
      controller.doubleTapCount.value += 1;
    } else {
      controller.doubleTapCount.value -= 1;
    }

    if (controller.doubleTapCount.value < 0) {
      controller.rewindIcons.value = false;
      controller.forwardIcons.value = true;
    } else {
      if (controller.doubleTapCount.value > 0) {
        controller.rewindIcons.value = true;
        controller.forwardIcons.value = false;
      } else {
        controller.rewindIcons.value = false;
        controller.forwardIcons.value = false;
      }
    }

    _doubleTapToSeekTimer?.cancel();
    _doubleTapToSeekTimer = Timer(const Duration(milliseconds: 500), () {
      playing = controller.playerStatus.playing;
      controller.videoSeekToNextSeconds(
          _defaultSeekAmount * controller.doubleTapCount.value, playing);
      controller.customDebugPrint("set tapped Twice to false");
      tappedTwice = false;
      controller.rewindIcons.value = false;
      controller.forwardIcons.value = false;
      controller.doubleTapCount.value = 0;
    });
  }

  void _forwardDragUpdate(
      Offset localPosition, MeeduPlayerController controller) {
    final double diff = _horizontalDragStartOffset.dx - localPosition.dx;
    final int duration = controller.duration.value.inSeconds;
    final int position = controller.position.value.inSeconds;
    final int seconds = -(diff * duration / 5000).round();
    final int relativePosition = position + seconds;
    if (relativePosition <= duration && relativePosition >= 0) {
      controller.swipeDuration.value = seconds;
    }
  }

  void _forwardDragEnd(MeeduPlayerController controller) async {
    _dragInitialDelta = Offset.zero;
    if (controller.swipeDuration.value != 0) {
      await controller.videoSeekToNextSeconds(
          controller.swipeDuration.value, playing);
    }
    controller.showSwipeDuration.value = false;
  }

  //----------------------------//
  void _volumeDragUpdate(
      Offset localPosition, MeeduPlayerController controller) {
    double diff = _verticalDragStartOffset.dy - localPosition.dy;
    double volume = (diff / 500) + _onDragStartVolume;
    if (volume >= 0 &&
        volume <= 1 &&
        differenceOfExists((controller.volume.value * 100).round(),
            (volume * 100).round(), 2)) {
      controller.customDebugPrint("Volume $volume");
      //customDebugPrint("current ${(controller.volume.value*100).round()}");
      //customDebugPrint("new ${(volume*100).round()}");
      controller.setVolume(volume);
    }
  }

  void _volumeDragStart(
      Offset localPosition, MeeduPlayerController controller) {
    controller.showVolumeStatus.value = true;
    controller.showBrightnessStatus.value = false;
    isVolume = true;
    _currentVolume.value = controller.volume.value;
    _onDragStartVolume = _currentVolume.value;
    _verticalDragStartOffset = localPosition;
  }

  void _volumeDragEnd(MeeduPlayerController controller) {
    _dragInitialDelta = Offset.zero;
    isVolume = false;
    controller.showVolumeStatus.value = false;
  }

  bool differenceOfExists(
      int originalValue, int valueToCompareTo, int difference) {
    bool plus = originalValue + difference < valueToCompareTo ||
        valueToCompareTo == 0 ||
        valueToCompareTo == 100;
    bool minus = originalValue - difference > valueToCompareTo;
    //customDebugPrint("originalValue"+(originalValue).toString());
    //customDebugPrint("valueToCompareTo"+(valueToCompareTo).toString());
    //customDebugPrint("originalValue+difference"+(originalValue+difference).toString());
    //customDebugPrint("originalValue-difference"+(originalValue-difference).toString());
    //customDebugPrint("plus "+plus.toString());
    //customDebugPrint("minus "+minus.toString());
    //customDebugPrint("______________________________________");
    if (plus || minus) {
      return true;
    } else {
      return false;
    }
  }

  void _brightnessDragUpdate(
      Offset localPosition, MeeduPlayerController controller) {
    double diff = _verticalDragStartOffset.dy - localPosition.dy;
    double brightness = (diff / 500) + _onDragStartBrightness;
    //customDebugPrint("New");
    //customDebugPrint((controller.brightness.value*100).round());
    //customDebugPrint((brightness*100).round());
    if (brightness >= 0 &&
        brightness <= 1 &&
        differenceOfExists((controller.brightness.value * 100).round(),
            (brightness * 100).round(), 2)) {
      controller.customDebugPrint("brightness $brightness");
      //brightness
      controller.setBrightness(brightness);
    }
  }

  void _brightnessDragStart(
      Offset localPosition, MeeduPlayerController controller) async {
    controller.showBrightnessStatus.value = true;
    controller.showVolumeStatus.value = false;

    _currentBrightness.value = controller.brightness.value;
    _onDragStartBrightness = _currentBrightness.value;
    _verticalDragStartOffset = localPosition;
  }

  void _brightnessDragEnd(MeeduPlayerController controller) {
    _dragInitialDelta = Offset.zero;
    controller.showBrightnessStatus.value = false;
    isVolume = false;
  }

  Widget controlsUI(MeeduPlayerController _, BuildContext context) {
    return Stack(children: [
      RxBuilder((__) {
        if (!_.mobileControls) {
          return MouseRegion(
              cursor: _.showControls.value
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.none,
              onHover: (___) {
                //customDebugPrint(___.delta);
                if (_.mouseMoveInitial < const Offset(75, 75).distance) {
                  _.mouseMoveInitial = _.mouseMoveInitial + ___.delta.distance;
                } else {
                  _.controls = true;
                }
              },
              child: videoControls(_, context));
        } else {
          return videoControls(_, context);
        }
      }),
      if (_.enabledControls.doubleTapToSeek && (_.mobileControls))
        RxBuilder(
          //observables: [_.showControls],
          (__) => IgnorePointer(
            ignoring: true,
            child: VideoCoreForwardAndRewind(
              responsive: widget.responsive,
              showRewind: _.rewindIcons.value,
              showForward: _.forwardIcons.value,
              rewindSeconds: _defaultSeekAmount * _.doubleTapCount.value,
              forwardSeconds: _defaultSeekAmount * _.doubleTapCount.value,
            ),
          ),
        ),
      if (_.enabledOverlays.volume)
        RxBuilder(
          //observables: [_.volume],
          (__) => AnimatedOpacity(
            duration: _.durations.volumeOverlayDuration,
            opacity: _.showVolumeStatus.value ? 1 : 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: widget.responsive.height / 2,
                    width: 35,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(color: Colors.black38),
                        Container(
                          height: _.volume.value * widget.responsive.height / 2,
                          color: Colors.blue,
                        ),
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      if (_.enabledOverlays.brightness)
        RxBuilder(
          //observables: [_.volume],
          (__) => AnimatedOpacity(
            duration: _.durations.brightnessOverlayDuration,
            opacity: _.showBrightnessStatus.value ? 1 : 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: widget.responsive.height / 2,
                    width: 35,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(color: Colors.black38),
                        Container(
                          height:
                              _.brightness.value * widget.responsive.height / 2,
                          color: Colors.blue,
                        ),
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.wb_sunny,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      RxBuilder(
        //observables: [_.showSwipeDuration],
        //observables: [_.swipeDuration],
        (__) => Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: _.durations.seekDuration,
            opacity: _.showSwipeDuration.value ? 1 : 0,
            child: Visibility(
              visible: _.showSwipeDuration.value,
              child: Container(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _.swipeDuration.value > 0
                        ? "+ ${printDuration(Duration(seconds: _.swipeDuration.value))}"
                        : "- ${printDuration(Duration(seconds: _.swipeDuration.value))}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      RxBuilder(
        //observables: [_.showSwipeDuration],
        //observables: [_.swipeDuration],
        (__) => Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: _.durations.videoFitOverlayDuration,
            opacity: _.videoFitChanged.value ? 1 : 0,
            child: Visibility(
              visible: _.videoFitChanged.value,
              child: Container(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _.videoFit.value.name[0].toUpperCase() +
                        _.videoFit.value.name.substring(1),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      RxBuilder(
          //observables: [_.showControls],
          (__) {
        _.dataStatus.status.value;
        if (_.dataStatus.error) {
          return Center(
              child: Text(
            _.errorText!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ));
        } else {
          return Container();
        }
      }),
      RxBuilder(
          //observables: [_.showControls],
          (__) {
        _.dataStatus.status.value;
        if (_.dataStatus.loading || _.isBuffering.value) {
          return Center(
            child: _.loadingWidget,
          );
        } else {
          return Container();
        }
      }),
    ]);
  }

  Widget videoControls(MeeduPlayerController _, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_.mobileControls) {
          if (tappedTwice) {
            if (_.enabledControls.desktopDoubleTapToFullScreen) {
              _.toggleFullScreen(context);
            }

            tappedOnce(_, true);
          } else {
            if (_.enabledControls.desktopTapToPlayAndPause) {
              _.togglePlay();
            }
            tappedOnce(_, false);
          }
        }
        _.controls = !_.showControls.value;
        _dragInitialDelta = Offset.zero;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (_.mobileControls && _.enabledControls.seekSwipes) {
          //if (!_.videoPlayerController!.value.isInitialized) {
          //return;
          //}

          //_.controls=true;
          final Offset position = details.localPosition;
          if (_dragInitialDelta == Offset.zero) {
            final Offset delta = details.delta;
            if (details.localPosition.dx > widget.responsive.width * 0.1 &&
                ((widget.responsive.width - details.localPosition.dx) >
                        widget.responsive.width * 0.1 &&
                    !gettingNotification)) {
              _forwardDragStart(position, _);
              _dragInitialDelta = delta;
            } else {
              _.customDebugPrint("##############out###############");
              gettingNotification = true;
            }
          }
          if (!gettingNotification) {
            _forwardDragUpdate(position, _);
          }
        }

        //_.videoPlayerController!.seekTo(position);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_.mobileControls && _.enabledControls.seekSwipes) {
          //if (!_.videoPlayerController!.value.isInitialized) {
          //return;
          //}
          gettingNotification = false;
          _forwardDragEnd(_);
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (_.mobileControls) {
          //if (!_.videoPlayerController!.value.isInitialized) {
          //return;
          //}
          //_.controls=true;

          final Offset position = details.localPosition;
          if (_dragInitialDelta == Offset.zero) {
            _.customDebugPrint(details.localPosition.dy);
            if (details.localPosition.dy > widget.responsive.height * 0.1 &&
                ((widget.responsive.height - details.localPosition.dy) >
                    widget.responsive.height * 0.1) &&
                !gettingNotification) {
              final Offset delta = details.delta;
              //if(details.localPosition.dy<30){
              if (details.localPosition.dx >= widget.responsive.width / 2) {
                if (_.enabledControls.volumeSwipes) {
                  _volumeDragStart(position, _);
                }
                _dragInitialDelta = delta;
                //customDebugPrint("right");
              } else {
                if (_.mobileControls && _.enabledControls.brightnessSwipes) {
                  _brightnessDragStart(position, _);
                }
                _dragInitialDelta = delta;
                //customDebugPrint("left");
              }
            } else {
              _.customDebugPrint("getting Notification");
              gettingNotification = true;
            }
            //}
          } else {
            if (!gettingNotification) {
              if (isVolume && _.enabledControls.volumeSwipes) {
                _volumeDragUpdate(position, _);
              } else {
                if (_.mobileControls && _.enabledControls.brightnessSwipes) {
                  _brightnessDragUpdate(position, _);
                }
              }
            }
          }
        }
        //_.videoPlayerController!.seekTo(position);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (_.mobileControls) {
          //if (!_.videoPlayerController!.value.isInitialized) {
          // return;
          //}
          gettingNotification = false;
          if (isVolume && _.enabledControls.volumeSwipes) {
            _volumeDragEnd(_);
          } else {
            if (_.mobileControls && _.enabledControls.brightnessSwipes) {
              _brightnessDragEnd(_);
            }
          }
        }
      },
      child: AnimatedOpacity(
        opacity: _.showControls.value ? 1 : 0,
        duration: _.durations.controlsDuration,
        child: AnimatedContainer(
            duration: _.durations.controlsDuration,
            color: _.showControls.value ? Colors.black26 : Colors.transparent,
            child: Stack(
              children: [
                if (_.enabledControls.doubleTapToSeek && (_.mobileControls))
                  Positioned.fill(
                    bottom: widget.responsive.height * 0.20,
                    top: widget.responsive.height * 0.20,
                    child: VideoCoreForwardAndRewindLayout(
                      responsive: widget.responsive,
                      rewind: GestureDetector(
                        // behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (_.doubleTapCount.value != 0 || tappedTwice) {
                            _rewind(context, _);
                            tappedOnce(_, true);
                          } else {
                            tappedOnce(_, false);
                          }
                        },
                      ),
                      forward: GestureDetector(
                        // behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (_.doubleTapCount.value != 0 || tappedTwice) {
                            _forward(context, _);
                            tappedOnce(_, true);
                          } else {
                            tappedOnce(_, false);
                          }
                        },
                        //behavior: HitTestBehavior.,
                      ),
                    ),
                  ),
                IgnorePointer(
                    ignoring: !_.showControls.value, child: widget.child),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);

    return Positioned.fill(child: controlsUI(_, context));
  }
}
