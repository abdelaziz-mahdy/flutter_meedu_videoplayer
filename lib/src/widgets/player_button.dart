import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final double size;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgrounColor, iconColor;
  final bool circle;
  final Widget? customIcon;

  const PlayerButton({
    Key? key,
    this.size = 40,
    required this.iconPath,
    required this.onPressed,
    this.circle = true,
    this.backgrounColor = Colors.white54,
    this.iconColor = Colors.black,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 20,
      child: customIcon ??
          Container(
            width: this.size,
            height: this.size,
            padding: EdgeInsets.all(this.size * 0.25),
            child: Image.asset(
              this.iconPath,
              color: this.iconColor,
              //package: 'meedu_player',
            ),
            decoration: BoxDecoration(
              color: this.backgrounColor,
              shape: this.circle ? BoxShape.circle : BoxShape.rectangle,
            ),
          ),
      onPressed: this.onPressed,
    );
  }
}
